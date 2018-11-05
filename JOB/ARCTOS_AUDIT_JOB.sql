
  
BEGIN 
dbms_scheduler.create_job('"ARCTOS_AUDIT_JOB"',
job_type=>'STORED_PROCEDURE', job_action=>
'sp_arctos_audit_insert'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('30-APR-2010 12.00.00.000000000 AM AMERICA/NEW_YORK','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'freq=daily; byhour=1; byminute=16'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>TRUE,comments=>
'insert daily fga audit records into arctos_audit'
);
dbms_scheduler.enable('"ARCTOS_AUDIT_JOB"');
COMMIT; 
END; 
