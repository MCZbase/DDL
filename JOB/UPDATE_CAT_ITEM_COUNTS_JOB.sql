
  
BEGIN 
dbms_scheduler.create_job('"UPDATE_CAT_ITEM_COUNTS_JOB"',
job_type=>'STORED_PROCEDURE', job_action=>
'MCZBASE.UPDATE_CAT_ITEM_COUNTS'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('08-FEB-2022 11.26.25.525565000 AM AMERICA/NEW_YORK','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Updates cf_geog_cat_item_counts for the browse specimens page.'
);
dbms_scheduler.enable('"UPDATE_CAT_ITEM_COUNTS_JOB"');
COMMIT; 
END; 
