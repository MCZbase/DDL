
  CREATE TABLE "TAXON_RELATIONS" 
   (	"TAXON_NAME_ID" NUMBER(10,0) NOT NULL ENABLE, 
	"RELATED_TAXON_NAME_ID" NUMBER(10,0) NOT NULL ENABLE, 
	"TAXON_RELATIONSHIP" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"RELATION_AUTHORITY" VARCHAR2(45 CHAR), 
	 CONSTRAINT "PKEY_TAXON_RELATIONS" PRIMARY KEY ("TAXON_NAME_ID", "RELATED_TAXON_NAME_ID", "TAXON_RELATIONSHIP")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_TAXONRELN_TAXONOMY_RTNID" FOREIGN KEY ("RELATED_TAXON_NAME_ID")
	  REFERENCES "TAXONOMY" ("TAXON_NAME_ID") ENABLE, 
	 CONSTRAINT "FK_TAXONRELN_TAXONOMY_TNID" FOREIGN KEY ("TAXON_NAME_ID")
	  REFERENCES "TAXONOMY" ("TAXON_NAME_ID") ENABLE
   ) 