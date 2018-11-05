
  
BEGIN 
dbms_scheduler.create_job('"VPD_COLL_LOC_STALE"',
job_type=>'STORED_PROCEDURE', job_action=>
'vpd_collection_locality_stale'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('20-AUG-2011 01.00.00.000000000 AM -04:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'freq=hourly; byminute=10,40;'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>TRUE,comments=>
'maintains stale records in vpd_collection_locality table'
);
dbms_scheduler.enable('"VPD_COLL_LOC_STALE"');
COMMIT; 
END; 
