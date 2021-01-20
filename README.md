# UKDS GeoConvert

Create API for [UKDS GeoConvert](http://geoconvert.ukdataservice.ac.uk/).

## Applying PostgreSQL Parameters

<details>
  <summary>Click to see more...</summary>
  
  ### Login
  
  1. Log into [AWS Single Sign-On](https://d-936702e084.awsapps.com/start#/).
  2. Go to the [RDS section](https://console.aws.amazon.com/rds/).
  3. In the left-hand menu, select 'Parameter groups'.
  
  ### Create Parameter Group
  
  You can't edit a **default** parameter group so you have to create a custom group to work with.
  
  1. In the top-right, click 'Create parameter group'.
  2. In the 'Parameter group family' dropdown, select 'postgres12'.
  3. Type in a meaningful name and a brief description.
  
  ### Edit Parameter Group
  
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

  ### Applying the Parameter Group

  1. Go back to the [RDS section](https://console.aws.amazon.com/rds/).
  2. Click on 'DB Instances'.
  3. Click on the database you are working with.
  4. In the top-right, click 'Modify'.
  5. Under 'Additional configuration > Database options', choose your newly created group in the 'DB parameter group' dropdown.
  
  ### Turning on Performance Insights (Optional)
  
  It is also recommended to turn on 'Performance Insights' if it is not active. Stick with the defaults for 'Retention period' and 'Master key'.
  
  ### Applying the Parameter Group (Continued)
  
  6. Scroll to the bottom and click 'Continue'.
  7. Review the summary of your changes and ensure the 'Apply immediately' checkbox is selected.
  8. Click 'Modify DB instance'. It will take a few minutes to apply the changes.
  
  ### Rebooting to Apply Changes
  
  1. Click on the database you are working with.
  2. Click on the 'Configuration' tab.
  3. You should see `(pending-reboot)` next to the 'Paramter group' value. In the top-right, click the 'Actions' dropdown and select 'Reboot'.
  4. Click 'Confirm'. Again, this will take a few minutes to complete.
</details>
