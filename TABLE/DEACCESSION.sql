
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
	 CONSTRAINT "FK_DEACCESSION_TRANS" FOREIGN KEY ("TRANSACTION_ID")
	  REFERENCES "TRANS" ("TRANSACTION_ID") ENABLE, 
	 CONSTRAINT "FK_DEACC_TYPE" FOREIGN KEY ("DEACC_TYPE")
	  REFERENCES "CTDEACC_TYPE" ("DEACC_TYPE") ENABLE, 
	 CONSTRAINT "FK_DEACC_STATUS" FOREIGN KEY ("DEACC_STATUS")
	  REFERENCES "CTDEACC_STATUS" ("DEACC_STATUS") ENABLE
   ) ;
COMMENT ON TABLE "DEACCESSION" IS 'Deaccessions are a sybtype of transactions (TRANS), which record the desctruction, transfer of ownership to another party, or other relinquishement of ownership of material by the MCZ.';
COMMENT ON COLUMN "DEACCESSION"."TRANSACTION_ID" IS 'Dependent key.  deaccessions are a subtype of transactions.';
COMMENT ON COLUMN "DEACCESSION"."DEACC_NUMBER" IS 'The number of the deaccession.';
COMMENT ON COLUMN "DEACCESSION"."DEACC_TYPE" IS 'The type of the deaccession.   Controlled vocabulary';
COMMENT ON COLUMN "DEACCESSION"."DEACC_STATUS" IS 'The current status of the deaccession,  Controlled vocabulary.';
COMMENT ON COLUMN "DEACCESSION"."DEACC_REASON" IS 'A text description of the reason the material was deaccessioned';
COMMENT ON COLUMN "DEACCESSION"."DEACC_DESCRIPTION" IS 'A description of the material in the deaccession.';
COMMENT ON COLUMN "DEACCESSION"."DEACC_REMARKS" IS 'Internal remarks related to the deaccession.';
COMMENT ON COLUMN "DEACCESSION"."CLOSED_BY" IS 'The agent who closed this deaccession.  Automatic.';
COMMENT ON COLUMN "DEACCESSION"."X_CLOSED_DATE" IS 'deprecated';
COMMENT ON COLUMN "DEACCESSION"."VALUE" IS 'Text remarks concerning the value or insurance of the deaccessioned material.';
COMMENT ON COLUMN "DEACCESSION"."METHOD" IS 'Text remarks concerning the method by which the deaccessioned material was transferred away from the MCZ.';
