
  CREATE TABLE "CTJOURNAL_NAME" 
   (	"JOURNAL_NAME" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"SHORT_NAME" VARCHAR2(255), 
	"ISSN" VARCHAR2(255), 
	"START_YEAR" NUMBER, 
	"END_YEAR" NUMBER, 
	"REMARKS" VARCHAR2(2000), 
	 CONSTRAINT "PK_CTJOURNAL_NAME" PRIMARY KEY ("JOURNAL_NAME")
  USING INDEX  ENABLE
   ) 