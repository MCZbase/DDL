
  CREATE TABLE "ELECTRONIC_ADDRESS" 
   (	"AGENT_ID" NUMBER NOT NULL ENABLE, 
	"ADDRESS_TYPE" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"ADDRESS" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"ELECTRONIC_ADDRESS_ID" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "ELECTRONIC_ADDRESS_PK" PRIMARY KEY ("ELECTRONIC_ADDRESS_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_E_ADDRESS_AGENT" FOREIGN KEY ("AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) 