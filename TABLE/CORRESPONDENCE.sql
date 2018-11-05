
  CREATE TABLE "CORRESPONDENCE" 
   (	"CORRESPONDENCE_ID" NUMBER(38,0) NOT NULL ENABLE, 
	"CORRESPONDENCE_TYPE" NUMBER(25,0) NOT NULL ENABLE, 
	"FROM_AGENT_ADDR_ID" NUMBER(15,0), 
	"TO_AGENT_ADDR_ID" NUMBER(15,0), 
	"WRITTEN_DATE" DATE, 
	"FOLDER_LABEL" VARCHAR2(40 CHAR), 
	"FILED_UNDER_NAME" VARCHAR2(120 CHAR) NOT NULL ENABLE, 
	"CORRESPONDENCE_REMARKS" VARCHAR2(255 CHAR), 
	 CONSTRAINT "PK_CORRESPONDENCE" PRIMARY KEY ("CORRESPONDENCE_ID")
  USING INDEX  ENABLE
   ) 