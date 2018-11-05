
  CREATE TABLE "AGENT" 
   (	"AGENT_ID" NUMBER(15,0) NOT NULL ENABLE, 
	"AGENT_TYPE" VARCHAR2(30) NOT NULL ENABLE, 
	"AGENT_REMARKS" VARCHAR2(4000), 
	"PREFERRED_AGENT_NAME_ID" NUMBER NOT NULL ENABLE, 
	"EDITED" CHAR(1 CHAR), 
	 CONSTRAINT "PK_AGENT_ID" PRIMARY KEY ("AGENT_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CTAGENT_TYPE" FOREIGN KEY ("AGENT_TYPE")
	  REFERENCES "CTAGENT_TYPE" ("AGENT_TYPE") ENABLE
   ) 