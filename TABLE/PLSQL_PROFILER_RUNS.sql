
  CREATE TABLE "PLSQL_PROFILER_RUNS" 
   (	"RUNID" NUMBER, 
	"RELATED_RUN" NUMBER, 
	"RUN_OWNER" VARCHAR2(32 CHAR), 
	"RUN_PROC" VARCHAR2(256 CHAR), 
	"RUN_DATE" DATE, 
	"RUN_COMMENT" VARCHAR2(2047 CHAR), 
	"RUN_TOTAL_TIME" NUMBER, 
	"RUN_SYSTEM_INFO" VARCHAR2(2047 CHAR), 
	"RUN_COMMENT1" VARCHAR2(256 CHAR), 
	"SPARE1" VARCHAR2(256 CHAR), 
	 PRIMARY KEY ("RUNID")
  USING INDEX  ENABLE
   ) 