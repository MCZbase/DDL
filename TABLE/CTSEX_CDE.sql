
  CREATE TABLE "CTSEX_CDE" 
   (	"SEX_CDE" VARCHAR2(25) NOT NULL ENABLE, 
	"COLLECTION_CDE" VARCHAR2(10) NOT NULL ENABLE, 
	 PRIMARY KEY ("SEX_CDE", "COLLECTION_CDE")
  USING INDEX  ENABLE
   ) 