
  CREATE TABLE "CTABUNDANCE" 
   (	"COLLECTION_CDE" VARCHAR2(10) NOT NULL ENABLE, 
	"ABUNDANCE" VARCHAR2(60 CHAR) NOT NULL ENABLE, 
	 CONSTRAINT "PK_CTABUNDANCE" PRIMARY KEY ("COLLECTION_CDE", "ABUNDANCE")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CTABUNDANCE" FOREIGN KEY ("COLLECTION_CDE")
	  REFERENCES "CTCOLLECTION_CDE" ("COLLECTION_CDE") ENABLE
   ) 