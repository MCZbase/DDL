
  CREATE TABLE "CTUNDERSCORE_COLL_AGENT_ROLE" 
   (	"ROLE" VARCHAR2(50) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000), 
	"ORDINAL" NUMBER DEFAULT 1 NOT NULL ENABLE, 
	"LABEL" VARCHAR2(50), 
	"INVERSE_LABEL" VARCHAR2(50), 
	 CONSTRAINT "CT_UNDERSCORE_COLL_AGENT_R_PK" PRIMARY KEY ("ROLE")
  USING INDEX  ENABLE
   ) 