
  
BEGIN 
dbms_scheduler.create_job('"COMPUTE_STATISTICS"',
job_type=>'STORED_PROCEDURE', job_action=>
'COMPUTE_TABLE_STATISTICS'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('08-FEB-2023 02.56.05.323153000 PM AMERICA/NEW_YORK','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=WEEKLY; BYDAY=SUN; BYHOUR=00;'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>TRUE,comments=>
NULL
);
dbms_scheduler.enable('"COMPUTE_STATISTICS"');
COMMIT; 
END; 
