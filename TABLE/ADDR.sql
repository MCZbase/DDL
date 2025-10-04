
  CREATE TABLE "ADDR" 
   (	"ADDR_ID" NUMBER NOT NULL ENABLE, 
	"STREET_ADDR1" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"STREET_ADDR2" VARCHAR2(255 CHAR), 
	"CITY" VARCHAR2(60 CHAR) NOT NULL ENABLE, 
	"STATE" VARCHAR2(50), 
	"ZIP" VARCHAR2(20 CHAR), 
	"COUNTRY_CDE" VARCHAR2(50 CHAR), 
	"MAIL_STOP" VARCHAR2(20 CHAR), 
	"FORMATTED_ADDR" VARCHAR2(510 CHAR), 
	"AGENT_ID" NUMBER NOT NULL ENABLE, 
	"ADDR_TYPE" VARCHAR2(25 CHAR) NOT NULL ENABLE, 
	"JOB_TITLE" VARCHAR2(60 CHAR), 
	"VALID_ADDR_FG" NUMBER NOT NULL ENABLE, 
	"ADDR_REMARKS" VARCHAR2(255 CHAR), 
	"INSTITUTION" VARCHAR2(255 CHAR), 
	"DEPARTMENT" VARCHAR2(255 CHAR), 
	 CONSTRAINT "FK_CTADDR_TYPE" FOREIGN KEY ("ADDR_TYPE")
	  REFERENCES "CTADDR_TYPE" ("ADDR_TYPE") ENABLE, 
	 CONSTRAINT "FK_ADDR_AGENT" FOREIGN KEY ("AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) 
  CREATE UNIQUE INDEX "PKEY_ADDR" ON "ADDR" ("ADDR_ID") 
  
ALTER TABLE "ADDR" ADD CONSTRAINT "PK_ADDR" PRIMARY KEY ("ADDR_ID")
  USING INDEX "PKEY_ADDR"  ENABLE;
COMMENT ON TABLE "ADDR" IS 'A mailing address.';
COMMENT ON COLUMN "ADDR"."JOB_TITLE" IS 'Job title for the addressee, if part of the address.';
COMMENT ON COLUMN "ADDR"."VALID_ADDR_FG" IS 'Boolean flag indicating whether this address is currently valid for use on new shipments.';
COMMENT ON COLUMN "ADDR"."ADDR_REMARKS" IS 'Free text assertions concerning the address.';
COMMENT ON COLUMN "ADDR"."INSTITUTION" IS 'Name of the institution, if any, forming part of the address.';
COMMENT ON COLUMN "ADDR"."DEPARTMENT" IS 'Name of a department, if any, forming part of the address.';
COMMENT ON COLUMN "ADDR"."ADDR_ID" IS 'Surrogate numeric primary key';
COMMENT ON COLUMN "ADDR"."STREET_ADDR1" IS 'First line of the street address';
COMMENT ON COLUMN "ADDR"."STREET_ADDR2" IS 'Second line of the street address';
COMMENT ON COLUMN "ADDR"."CITY" IS 'City or Municipality portion of address.';
COMMENT ON COLUMN "ADDR"."STATE" IS 'Primary division (state/province) of the country for the address.';
COMMENT ON COLUMN "ADDR"."ZIP" IS 'Zip or postal code';
COMMENT ON COLUMN "ADDR"."COUNTRY_CDE" IS 'Two letter ISO country code for the country.';
COMMENT ON COLUMN "ADDR"."MAIL_STOP" IS 'Mail Stop, if any, forming part of the address.';
COMMENT ON COLUMN "ADDR"."FORMATTED_ADDR" IS 'Automatic.  Address assembled into a single multi-line text block as formatted for a mailing label.';
COMMENT ON COLUMN "ADDR"."AGENT_ID" IS 'Agent for whom this is an address';
COMMENT ON COLUMN "ADDR"."ADDR_TYPE" IS 'Type of address.';
