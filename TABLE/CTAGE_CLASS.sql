
  CREATE TABLE "CTAGE_CLASS" 
   (	"AGE_CLASS" VARCHAR2(21 CHAR) NOT NULL ENABLE, 
	"COLLECTION_CDE" VARCHAR2(10) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000 CHAR), 
	 PRIMARY KEY ("AGE_CLASS", "COLLECTION_CDE")
  USING INDEX  ENABLE
   ) 