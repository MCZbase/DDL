
  
BEGIN 
dbms_scheduler.create_job('"GARBAGE_COLLECTION"',
job_type=>'STORED_PROCEDURE', job_action=>
'USER_SEARCH_GARBAGECOLLECTION'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('08-FEB-2023 02.59.25.335025000 PM AMERICA/NEW_YORK','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=WEEKLY; BYDAY=SAT; BYHOUR=01;'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>TRUE,comments=>
NULL
);
dbms_scheduler.enable('"GARBAGE_COLLECTION"');
COMMIT; 
END; 
