
  CREATE TABLE "DEACCESSION" 
   (	"TRANSACTION_ID" NUMBER, 
	"DEACC_NUMBER" VARCHAR2(60 CHAR), 
	"DEACC_TYPE" VARCHAR2(25 CHAR), 
	"DEACC_STATUS" VARCHAR2(25 CHAR), 
	"DEACC_REASON" VARCHAR2(4000 CHAR), 
	"DEACC_DESCRIPTION" VARCHAR2(4000 CHAR), 
	"DEACC_REMARKS" VARCHAR2(4000 CHAR), 
	"CLOSED_BY" VARCHAR2(50), 
	"X_CLOSED_DATE" DATE, 
	"VALUE" VARCHAR2(50), 
	"METHOD" VARCHAR2(4000 CHAR), 
	 CONSTRAINT "PK_DEACCESSION" PRIMARY KEY ("TRANSACTION_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_DEACC_TYPE" FOREIGN KEY ("DEACC_TYPE")
	  REFERENCES "CTDEACC_TYPE" ("DEACC_TYPE") ENABLE, 
	 CONSTRAINT "FK_DEACC_STATUS" FOREIGN KEY ("DEACC_STATUS")
	  REFERENCES "CTDEACC_STATUS" ("DEACC_STATUS") ENABLE, 
	 CONSTRAINT "FK_DEACCESSION_TRANS" FOREIGN KEY ("TRANSACTION_ID")
	  REFERENCES "TRANS" ("TRANSACTION_ID") ENABLE
   ) 