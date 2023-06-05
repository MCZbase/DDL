
  CREATE TABLE "UNDERSCORE_COLLECTION_CITATION" 
   (	"UNDERSCORE_COLL_CITATION_ID" NUMBER NOT NULL ENABLE, 
	"UNDERSCORE_COLLECTION_ID" NUMBER NOT NULL ENABLE, 
	"PUBLICATION_ID" NUMBER NOT NULL ENABLE, 
	"TYPE" VARCHAR2(50) NOT NULL ENABLE, 
	"PAGES" VARCHAR2(255), 
	"REMARKS" VARCHAR2(4000), 
	"CITATION_PAGE_URI" VARCHAR2(4000), 
	"CREATED_BY_AGENT_ID" NUMBER NOT NULL ENABLE, 
	"DATE_CREATED" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP NOT NULL ENABLE, 
	"LAST_UPDATED_BY_AGENT_ID" NUMBER, 
	"DATE_LAST_UPDATED" TIMESTAMP (6), 
	 CONSTRAINT "UNDERSCORE_COLLECTION_CITA_PK" PRIMARY KEY ("UNDERSCORE_COLL_CITATION_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "UNDERSCORE_COLLECTION_CIT_FK1" FOREIGN KEY ("PUBLICATION_ID")
	  REFERENCES "PUBLICATION" ("PUBLICATION_ID") ENABLE, 
	 CONSTRAINT "UNDERSCORE_COLLECTION_CIT_FK2" FOREIGN KEY ("UNDERSCORE_COLLECTION_ID")
	  REFERENCES "UNDERSCORE_COLLECTION" ("UNDERSCORE_COLLECTION_ID") ENABLE, 
	 CONSTRAINT "UNDERSCORE_COLLECTION_CIT_FK3" FOREIGN KEY ("TYPE")
	  REFERENCES "CTUNDERSCORE_COLL_CIT_TYPE" ("TYPE") ENABLE
   ) 