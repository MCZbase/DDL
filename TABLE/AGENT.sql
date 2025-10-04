
  CREATE TABLE "AGENT" 
   (	"AGENT_ID" NUMBER(15,0) NOT NULL ENABLE, 
	"AGENT_TYPE" VARCHAR2(30) NOT NULL ENABLE, 
	"AGENT_REMARKS" VARCHAR2(4000), 
	"PREFERRED_AGENT_NAME_ID" NUMBER NOT NULL ENABLE, 
	"EDITED" CHAR(1 CHAR), 
	"AGENTGUID_GUID_TYPE" VARCHAR2(255), 
	"AGENTGUID" VARCHAR2(900), 
	"BIOGRAPHY" VARCHAR2(4000), 
	"EORI_NUMBER" VARCHAR2(30), 
	 CONSTRAINT "FK_CTAGENT_TYPE" FOREIGN KEY ("AGENT_TYPE")
	  REFERENCES "CTAGENT_TYPE" ("AGENT_TYPE") ENABLE
   ) 
  CREATE UNIQUE INDEX "PK_AGENT_ID" ON "AGENT" ("AGENT_ID") 
  
ALTER TABLE "AGENT" ADD CONSTRAINT "PK_AGENT_ID" PRIMARY KEY ("AGENT_ID")
  USING INDEX "PK_AGENT_ID"  ENABLE;
COMMENT ON TABLE "AGENT" IS 'A person, group of people, organization, or other entity having some role with regards to natural science collections.';
COMMENT ON COLUMN "AGENT"."AGENT_ID" IS 'surrogate numeric primary key';
COMMENT ON COLUMN "AGENT"."AGENT_TYPE" IS 'person, or other type of agent.  Agents of type person have corresponding record in the person table.';
COMMENT ON COLUMN "AGENT"."AGENT_REMARKS" IS 'Internal biographical information and other internal remarks.';
COMMENT ON COLUMN "AGENT"."PREFERRED_AGENT_NAME_ID" IS 'The prefered form of the name of the agent.';
COMMENT ON COLUMN "AGENT"."EDITED" IS 'agent record has been vetted (if value is 1)';
COMMENT ON COLUMN "AGENT"."AGENTGUID_GUID_TYPE" IS 'The type of GUID (e.g. ORCID or VIAF) found in AGENTGUID.';
COMMENT ON COLUMN "AGENT"."AGENTGUID" IS 'A globaly unique indetifier for this agent, suitable for serving in Darwin Core as dwciri:identifiedBy, dwciri:recordedBy, dwciri:georeferencedBy etc.';
COMMENT ON COLUMN "AGENT"."BIOGRAPHY" IS 'Biographical information to be provided to the public.';
COMMENT ON COLUMN "AGENT"."EORI_NUMBER" IS 'European  Economic Operators Registration and Identification number. Two letter country code, followed by up to 15 alphanumeric characters.';
