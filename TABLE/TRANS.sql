
  CREATE TABLE "TRANS" 
   (	"TRANSACTION_ID" NUMBER NOT NULL ENABLE, 
	"AUTH_AGENT_ID" NUMBER, 
	"TRANS_DATE" DATE, 
	"TRANS_ENTERED_AGENT_ID" NUMBER, 
	"RECEIVED_AGENT_ID" NUMBER, 
	"CORRESP_FG" NUMBER, 
	"TRANSACTION_TYPE" VARCHAR2(18 CHAR) NOT NULL ENABLE, 
	"NATURE_OF_MATERIAL" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	"TRANS_REMARKS" VARCHAR2(4000 CHAR), 
	"INSTITUTION_ACRONYM" VARCHAR2(20 CHAR), 
	"TRANS_AGENCY_ID" NUMBER, 
	"COLLECTION_ID" NUMBER NOT NULL ENABLE, 
	"IS_PUBLIC_FG" NUMBER(1,0), 
	 PRIMARY KEY ("TRANSACTION_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "TRANS_CORRESP_FG" CHECK (CORRESP_FG IN (0,1)) ENABLE, 
	 CONSTRAINT "TRANS_TRANSACTION_TYPE" CHECK (TRANSACTION_TYPE IN ('accn', 'loan', 'borrow', 'deaccession')) ENABLE, 
	 CONSTRAINT "FK_TRANS_ENTERED_AGENT_ID" FOREIGN KEY ("TRANS_ENTERED_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_TRANS_AGENCY_ID" FOREIGN KEY ("TRANS_AGENCY_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_AUTH_AGENT_ID" FOREIGN KEY ("AUTH_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_TRANS_COLLN" FOREIGN KEY ("COLLECTION_ID")
	  REFERENCES "COLLECTION" ("COLLECTION_ID") ENABLE
   ) 