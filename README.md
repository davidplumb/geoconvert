# UKDS GeoConvert

Create API for [UKDS GeoConvert](http://geoconvert.ukdataservice.ac.uk/).

## Database Tables

### `dbo.lut_postcode15jul`  
Contains a list of all UK postcodes (≈ 1.5M) along with associated metadata such as:

- Date of introduction/termination
- Lat-Long of centroid
- Areas postcode lies within, e.g. OA, LSOA, MSOA
- Deprivation score
- Population
- ...

The database is almost identical to the [ONS Postcode Directory (ONSPD)](https://geoportal.statistics.gov.uk/search?collection=Dataset&sort=-created&tags=all(PRD_ONSPD)).  
This version is from July 2015 (denoted by the '15jul' suffixes) and so is slightly behind the latest offered by the ONS.

The column names in the table are difficult to translate and so there is also a lookup in the following table.

<hr />

### `dbo.index_pdfield`  
Contains metadata about the columns in `dbo.lut_postcode15jul`.  
The most useful column in this is `field_label` as it contains the human-readable description.

*N.B. The `geoginst` column contains the column names in uppercase. When linking to the `dbo.lut_postcode15jul` table, it is recommended to use the `geoginst_lower` column.*

<hr />

### `dbo.index_lut`  
Contains a list of all the cross-geography, cross-census conversions available, e.g.

| lut_id                     | geoginst_1  | geoginst_2 |
|----------------------------|-------------|------------|
| LUT_DIST0115jul_RGN1115jul | DIST0115jul | RGN1115jul |

Breaking down the example above:  
*LUT_{`geography_1`}{`census_1`}15jul_{`geography_2`}{`census_2`}15jul*

- LUT stands for Look-Up Table (and can be ignored)
- DIST stands for Districts
- 01 stands for the 2001 Census
- 15jul stands for the version of the database (and can be ignored)
- RGN stands for Regions
- 11 stands for the 2011 Census
- 15jul stands for the version of the database (and can be ignored again)

Therefore, the lookup between 2001 Districts and 2011 Regions exists.  
The proportional lookups can be found in `dbo.lut_dist0115jul_rgn1115jul`.

<hr />

### `dbo.lut_dist0115jul_rgn1115jul` (Example)  
Contains the proportional lookups between the two zones (Districts to Regions in this case).

| zone_code_1 | zone_code_2 | propn_1to2 | propn_2to1 |
|-------------|-------------|------------|------------|
| 00CH        | E12000001   | 1          | 0.0770989  |

The example above shows 00CH (the 2001 code for the district of Gateshead) and E12000001 (the 2011 code for the North East region of England).  
The 'propn_1to2' column contains 1 because Gateshead lies fully within the North East, which is what you'd expect.  
The 'propn_2to1' contains 0.0770989 because Gateshead makes up about 7.7% of the North East along with approximately 22 other districts.

<hr />

## Amendments to Database Tables

### `dbo.index_lut`

New columns added to help filter lookups and identify tables:

- lut_id_lower - *All the proportional lookup tables in the database have lowercase names.*
- geoginst_1_area - *The geographical layer for the source geography.*
- geoginst_1_year - *The census year for the source geography.*
- geoginst_2_area - *The geographical layer for the target geography.*
- geoginst_2_year - *The census year for the target geography.*

The first column allows tables to be more easily identified.  
The last four columns help with filtering.

<hr />

### `dbo.index_pdfield`

New column added to help identify columns in `dbo.lut_postcode15jul` (currently required for the API):

- geoginst_lower - *All the columns in `dbo.lut_postcode15jul` have lowercase names.*

<hr />

### `dbo.lut_postcode15jul`

Unique index added to `pcstrip15jul` to optimise postcode searches.

<hr />
<br />

### Applying PostgreSQL Parameters Manually

<details>
  <summary>Click to see more...</summary>
  
  It is preferable to set the parameters when creating the database in Terraform.  
  These are the instructions if you want to do so manually.
  
  #### Login
  
  1. Log into [AWS Single Sign-On](https://d-936702e084.awsapps.com/start#/).
  2. Go to the [RDS section](https://console.aws.amazon.com/rds/).
  3. In the left-hand menu, select 'Parameter groups'.
  
  #### Create Parameter Group
  
  You can't edit a **default** parameter group so you have to create a custom group to work with.
  
  1. In the top-right, click 'Create parameter group'.
  2. In the 'Parameter group family' dropdown, select 'postgres12'.
  3. Type in a meaningful name and a brief description.
  
  #### Edit Parameter Group
  
  1. Click on the parameter group to see the parameters.
  2. In the top-right, click 'Edit parameters'.
  
  The parameter values below are based on recommendations from [PG Config](https://www.pgconfig.org/).  
  N.B. Not all recommendations are compatible so only some of the recommendations were implemented.
  
  3. Change the following values (you can filter the parameters to more easily find them):  
```
| MEMORY                   |        |  
|--------------------------|--------|  
| work_mem                 | 3276   |  
| maintenance_work_mem     | 262144 |  

| CHECKPOINTS              |        |  
|--------------------------|--------|  
| min_wal_size             | 4096   |  
| max_wal_size             | 16384  |  
| wal_buffers              | -1     |  

| STORAGE                  |        |  
|--------------------------|--------|  
| random_page_cost         | 1.1    |  
| effective_io_concurrency | 200    |  
```

  #### Applying the Parameter Group

  1. Go back to the [RDS section](https://console.aws.amazon.com/rds/).
  2. Click on 'DB Instances'.
  3. Click on the database you are working with.
  4. In the top-right, click 'Modify'.
  5. Under 'Additional configuration > Database options', choose your newly created group in the 'DB parameter group' dropdown.
  
  #### Turning on Performance Insights (Optional)
  
  It is also recommended to turn on 'Performance Insights' if it is not active. Stick with the defaults for 'Retention period' and 'Master key'.
  
  #### Applying the Parameter Group (Continued)
  
  6. Scroll to the bottom and click 'Continue'.
  7. Review the summary of your changes and ensure the 'Apply immediately' checkbox is selected.
  8. Click 'Modify DB instance'. It will take a few minutes to apply the changes.
  
  #### Rebooting to Apply Changes
  
  1. Click on the database you are working with.
  2. Click on the 'Configuration' tab.
  3. You should see `(pending-reboot)` next to the 'Paramter group' value. In the top-right, click the 'Actions' dropdown and select 'Reboot'.
  4. Click 'Confirm'. Again, this will take a few minutes to complete.
</details>
