
  CREATE TABLE "CTSPECPART_ATTRIBUTE_TYPE" 
   (	"ATTRIBUTE_TYPE" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000 CHAR), 
	 CONSTRAINT "PK_CTPECPART_ATTRIBUTE_TYPE" PRIMARY KEY ("ATTRIBUTE_TYPE")
  USING INDEX  ENABLE
   ) 