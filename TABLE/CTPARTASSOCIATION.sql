
  CREATE TABLE "CTPARTASSOCIATION" 
   (	"COLLECTION_CDE" VARCHAR2(10), 
	"PARTASSOCIATION" VARCHAR2(60 CHAR), 
	 CONSTRAINT "PK_CTPARTASSOCIATION" PRIMARY KEY ("COLLECTION_CDE", "PARTASSOCIATION")
  USING INDEX  ENABLE
   ) 