
  CREATE TABLE "CTBIOL_RELATIONS" 
   (	"BIOL_INDIV_RELATIONSHIP" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"INVERSE_RELATION" VARCHAR2(30 CHAR), 
	"REL_TYPE" VARCHAR2(25 CHAR) DEFAULT 'biological' NOT NULL ENABLE, 
	 CONSTRAINT "PKEY_CTBIOL_RELATIONS" PRIMARY KEY ("BIOL_INDIV_RELATIONSHIP")
  USING INDEX  ENABLE
   ) 