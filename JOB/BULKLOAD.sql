
  
BEGIN 
dbms_scheduler.create_job('"BULKLOAD"',
job_type=>'STORED_PROCEDURE', job_action=>
'"BULK_PKG"."CHECK_AND_LOAD"'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('20-NOV-2008 04.02.25.622785000 PM -05:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=HOURLY'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>TRUE,comments=>
'load records in bulkloader where loaded is NULL'
);
dbms_scheduler.enable('"BULKLOAD"');
COMMIT; 
END; 
