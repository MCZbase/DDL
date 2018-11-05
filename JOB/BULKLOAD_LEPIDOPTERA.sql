
  
BEGIN 
dbms_scheduler.create_job('"BULKLOAD_LEPIDOPTERA"',
job_type=>'STORED_PROCEDURE', job_action=>
'"MCZBASE"."LEPIDOPTERA_LOAD_JOB"'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('05-MAR-2015 04.55.49.573120000 PM -05:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=HOURLY'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>TRUE,comments=>
'move records from lepidoptera db on crow to mczbase and attempt to load'
);
dbms_scheduler.enable('"BULKLOAD_LEPIDOPTERA"');
COMMIT; 
END; 
