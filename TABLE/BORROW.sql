
  CREATE TABLE "BORROW" 
   (	"TRANSACTION_ID" NUMBER NOT NULL ENABLE, 
	"LENDERS_TRANS_NUM_CDE" VARCHAR2(255 CHAR), 
	"LENDERS_INVOICE_RETURNED_FG" NUMBER NOT NULL ENABLE, 
	"RECEIVED_DATE" DATE, 
	"DUE_DATE" DATE, 
	"LENDERS_LOAN_DATE" DATE, 
	"BORROW_STATUS" VARCHAR2(20 CHAR), 
	"LENDERS_INSTRUCTIONS" VARCHAR2(4000 CHAR), 
	"LENDER_LOAN_TYPE" VARCHAR2(60 CHAR), 
	"BORROW_NUMBER" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"NO_OF_SPECIMENS" VARCHAR2(20 CHAR), 
	"DESCRIPTION_OF_BORROW" VARCHAR2(4000 CHAR), 
	"RETURN_ACKNOWLEDGED_DATE" DATE, 
	"RET_ACKNOWLEDGED_BY" VARCHAR2(50 CHAR), 
	 CONSTRAINT "FK_BORROW_TRANS" FOREIGN KEY ("TRANSACTION_ID")
	  REFERENCES "TRANS" ("TRANSACTION_ID") ENABLE, 
	 CONSTRAINT "FK_CTBORROW_STATUS" FOREIGN KEY ("BORROW_STATUS")
	  REFERENCES "CTBORROW_STATUS" ("BORROW_STATUS") ENABLE
   ) 
  CREATE UNIQUE INDEX "PKEY_BORROW" ON "BORROW" ("TRANSACTION_ID") 
  
ALTER TABLE "BORROW" ADD CONSTRAINT "PK_BORROW" PRIMARY KEY ("TRANSACTION_ID")
  USING INDEX "PKEY_BORROW"  ENABLE;
COMMENT ON TABLE "BORROW" IS 'Borrows are a subtype of transaction (TRANS) where material temporarily comes on loan from another institution to the MCZ.  Material in a borrow is not cataloged into the collections of the MCZ.   ';
COMMENT ON COLUMN "BORROW"."TRANSACTION_ID" IS 'dependent key';
COMMENT ON COLUMN "BORROW"."LENDERS_TRANS_NUM_CDE" IS 'Lender''s loan number';
COMMENT ON COLUMN "BORROW"."LENDERS_INVOICE_RETURNED_FG" IS 'flag to indicate that lender has acknowledged that the borrow has been returned to them.  1 marks acknowlegement.';
COMMENT ON COLUMN "BORROW"."RECEIVED_DATE" IS 'Date the borrow was received at the MCZ.';
COMMENT ON COLUMN "BORROW"."DUE_DATE" IS 'Date the borrow is due to be returned';
COMMENT ON COLUMN "BORROW"."LENDERS_LOAN_DATE" IS 'Lender''s date for the borrow.';
COMMENT ON COLUMN "BORROW"."BORROW_STATUS" IS 'Current lifecycle state for the borrow.   ';
COMMENT ON COLUMN "BORROW"."LENDERS_INSTRUCTIONS" IS 'Free text instructions from the lender concerning the handling of the material in the borrow.';
COMMENT ON COLUMN "BORROW"."LENDER_LOAN_TYPE" IS 'Loan type asserted by the lender (e.g. returnable, consumable, etc.).';
COMMENT ON COLUMN "BORROW"."BORROW_NUMBER" IS 'Identifier assigned to the borrow by the MCZ.';
COMMENT ON COLUMN "BORROW"."NO_OF_SPECIMENS" IS 'Total number of specimens in the borrow.';
COMMENT ON COLUMN "BORROW"."DESCRIPTION_OF_BORROW" IS 'Free text description of the nature of the material in the borrow.';
COMMENT ON COLUMN "BORROW"."RETURN_ACKNOWLEDGED_DATE" IS 'Date on which the lender acknowledged the return of the material from the MCZ.';
COMMENT ON COLUMN "BORROW"."RET_ACKNOWLEDGED_BY" IS 'Person who made the acknowlegement of the return of the loan.';
