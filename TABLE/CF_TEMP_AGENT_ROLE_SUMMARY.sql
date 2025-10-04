
  CREATE TABLE "CF_TEMP_AGENT_ROLE_SUMMARY" 
   (	"TABLE_NAME" VARCHAR2(128 CHAR), 
	"AGENT_ID" NUMBER, 
	"COUNT" NUMBER, 
	"COLUMN_NAME" VARCHAR2(128 CHAR), 
	"AGENT_NAME" VARCHAR2(128 CHAR), 
	"LABEL" VARCHAR2(200 CHAR)
   ) ;
COMMENT ON TABLE "CF_TEMP_AGENT_ROLE_SUMMARY" IS 'This isn''t a temporary bulkloader table, but a data aggregation table supporting reporting on agent activity metrics.';
