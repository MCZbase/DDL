
  
BEGIN 
dbms_scheduler.create_job('"CHECK_FLAT_STALE"',
job_type=>'STORED_PROCEDURE', job_action=>
'"MCZBASE"."IS_FLAT_STALE"'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('20-AUG-2011 03.21.25.959674000 PM -04:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>TRUE,comments=>
'check flat for records marked as stale and update them'
);
dbms_scheduler.enable('"CHECK_FLAT_STALE"');
COMMIT; 
END; 
