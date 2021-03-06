
  CREATE TABLE "CF_REPORT_SQL" 
   (	"REPORT_ID" NUMBER NOT NULL ENABLE, 
	"REPORT_NAME" VARCHAR2(38 CHAR) NOT NULL ENABLE, 
	"REPORT_TEMPLATE" VARCHAR2(38 CHAR) NOT NULL ENABLE, 
	"SQL_TEXT_OLD" VARCHAR2(4000 CHAR), 
	"PRE_FUNCTION" VARCHAR2(50 CHAR), 
	"REPORT_FORMAT" VARCHAR2(50 CHAR) DEFAULT 'PDF' NOT NULL ENABLE, 
	"SQL_TEXT" CLOB, 
	"DESCRIPTION" VARCHAR2(2000 CHAR), 
	 CONSTRAINT "PK_CF_REPORT_SQL" PRIMARY KEY ("REPORT_ID")
  USING INDEX  ENABLE
   ) 