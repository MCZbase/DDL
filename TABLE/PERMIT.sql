
  CREATE TABLE "PERMIT" 
   (	"PERMIT_ID" NUMBER NOT NULL ENABLE, 
	"ISSUED_BY_AGENT_ID" NUMBER NOT NULL ENABLE, 
	"ISSUED_DATE" DATE, 
	"ISSUED_TO_AGENT_ID" NUMBER NOT NULL ENABLE, 
	"RENEWED_DATE" DATE, 
	"EXP_DATE" DATE, 
	"PERMIT_NUM" VARCHAR2(255 CHAR), 
	"PERMIT_TYPE" VARCHAR2(100 CHAR) NOT NULL ENABLE, 
	"PERMIT_REMARKS" VARCHAR2(300 CHAR), 
	"CONTACT_AGENT_ID" NUMBER, 
	"PARENT_PERMIT_ID" NUMBER, 
	"RESTRICTION_SUMMARY" VARCHAR2(4000), 
	"BENEFITS_SUMMARY" VARCHAR2(4000), 
	"BENEFITS_PROVIDED" VARCHAR2(4000), 
	"SPECIFIC_TYPE" VARCHAR2(255), 
	"PERMIT_TITLE" VARCHAR2(255), 
	 CONSTRAINT "PK_PERMIT" PRIMARY KEY ("PERMIT_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CTPERMIT_TYPE" FOREIGN KEY ("PERMIT_TYPE")
	  REFERENCES "CTPERMIT_TYPE" ("PERMIT_TYPE") ENABLE, 
	 CONSTRAINT "FK_PARENT_PERMIT_ID" FOREIGN KEY ("PARENT_PERMIT_ID")
	  REFERENCES "PERMIT" ("PERMIT_ID") ENABLE, 
	 CONSTRAINT "PERMIT_FK1" FOREIGN KEY ("SPECIFIC_TYPE")
	  REFERENCES "CTSPECIFIC_PERMIT_TYPE" ("SPECIFIC_TYPE") ENABLE, 
	 CONSTRAINT "FK_PERMIT_BYAGENT" FOREIGN KEY ("ISSUED_BY_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_PERMIT_TOAGENT" FOREIGN KEY ("ISSUED_TO_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_PERMIT_CONTACTAGENT" FOREIGN KEY ("CONTACT_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) 