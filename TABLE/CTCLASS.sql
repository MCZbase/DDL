
  CREATE TABLE "CTCLASS" 
   (	"PHYLCLASS" VARCHAR2(20 CHAR), 
	"DESCRIPTION" VARCHAR2(4000 CHAR), 
	 CONSTRAINT "PKEY_CTCLASS" PRIMARY KEY ("PHYLCLASS")
  USING INDEX  ENABLE
   ) 