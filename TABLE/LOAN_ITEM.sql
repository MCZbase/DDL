
  CREATE TABLE "LOAN_ITEM" 
   (	"TRANSACTION_ID" NUMBER NOT NULL ENABLE, 
	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"RECONCILED_BY_PERSON_ID" NUMBER NOT NULL ENABLE, 
	"RECONCILED_DATE" DATE, 
	"ITEM_DESCR" VARCHAR2(127 CHAR) NOT NULL ENABLE, 
	"ITEM_INSTRUCTIONS" VARCHAR2(255 CHAR), 
	"LOAN_ITEM_REMARKS" VARCHAR2(255 CHAR), 
	"CREATED_BY_AGENT_ID" NUMBER, 
	"CREATED_DATE" DATE, 
	"LOAN_ITEM_ID" NUMBER NOT NULL ENABLE, 
	"RETURN_DATE" DATE, 
	"RESOLUTION_RECORDED_BY_AGENT_ID" NUMBER, 
	"RESOLUTION_REMARKS" VARCHAR2(4000), 
	"LOAN_ITEM_STATE" VARCHAR2(50), 
	 CONSTRAINT "LOAN_ITEM_PK" PRIMARY KEY ("LOAN_ITEM_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_LOANITEM_LOAN" FOREIGN KEY ("TRANSACTION_ID")
	  REFERENCES "LOAN" ("TRANSACTION_ID") ENABLE, 
	 CONSTRAINT "FK_LOANITEM_COLLOBJ" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "COLL_OBJECT" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "LOAN_ITEM_FK1" FOREIGN KEY ("CREATED_BY_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_LOANITEM_RECONC_AGENT" FOREIGN KEY ("RECONCILED_BY_PERSON_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) ;
COMMENT ON TABLE "LOAN_ITEM" IS 'Entity recordign the participation of a specimen part in a loan, including item specific instructions and metadata on the lifecycle of the item with respect to the loan.';
COMMENT ON COLUMN "LOAN_ITEM"."LOAN_ITEM_STATE" IS 'Current State of the loan item with respect to the loan.';
COMMENT ON COLUMN "LOAN_ITEM"."RETURN_DATE" IS 'The date the loan item was returned.';
COMMENT ON COLUMN "LOAN_ITEM"."RESOLUTION_RECORDED_BY_AGENT_ID" IS 'The agent_id of the agent who marked the loan item as returned or consumed..';
COMMENT ON COLUMN "LOAN_ITEM"."RESOLUTION_REMARKS" IS 'Remarks concerning this item in relationship to the return of the loan (or the consumption of the material).';
COMMENT ON COLUMN "LOAN_ITEM"."TRANSACTION_ID" IS 'The loan that this item is in.';
COMMENT ON COLUMN "LOAN_ITEM"."COLLECTION_OBJECT_ID" IS 'The collection_object_id for the part that is this loan item';
COMMENT ON COLUMN "LOAN_ITEM"."RECONCILED_BY_PERSON_ID" IS 'Agent who added this loan item to the loan.  "Reconciled" is a missleading name that reflects a previous workflow of user loans being requested by users, then staff reconciling the addition of the material to the loan.';
COMMENT ON COLUMN "LOAN_ITEM"."RECONCILED_DATE" IS 'Date on which the loan item was added to the loan.';
COMMENT ON COLUMN "LOAN_ITEM"."ITEM_DESCR" IS 'Description of the item as it pertains to the loan.';
COMMENT ON COLUMN "LOAN_ITEM"."ITEM_INSTRUCTIONS" IS 'Instructions for handling the item in the loan';
COMMENT ON COLUMN "LOAN_ITEM"."LOAN_ITEM_REMARKS" IS 'Remarks concerning this item in this loan.
';
COMMENT ON COLUMN "LOAN_ITEM"."CREATED_BY_AGENT_ID" IS 'Agent who created the loan item record';
COMMENT ON COLUMN "LOAN_ITEM"."CREATED_DATE" IS 'Date the loan item record was created.';
COMMENT ON COLUMN "LOAN_ITEM"."LOAN_ITEM_ID" IS 'Surrogate numeric primary key';
