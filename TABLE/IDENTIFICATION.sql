
  CREATE TABLE "IDENTIFICATION" 
   (	"IDENTIFICATION_ID" NUMBER NOT NULL ENABLE, 
	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"DATE_MADE_DATE" DATE, 
	"NATURE_OF_ID" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"ACCEPTED_ID_FG" NUMBER NOT NULL ENABLE, 
	"IDENTIFICATION_REMARKS" VARCHAR2(4000 CHAR), 
	"TAXA_FORMULA" VARCHAR2(25 CHAR) NOT NULL ENABLE, 
	"SCIENTIFIC_NAME" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	"PUBLICATION_ID" NUMBER, 
	"SORT_ORDER" NUMBER(2,0), 
	"STORED_AS_FG" NUMBER(1,0) DEFAULT 0, 
	"MADE_DATE" VARCHAR2(22 CHAR), 
	 CONSTRAINT "FK_IDENTIFICATION_CATITEM" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "CATALOGED_ITEM" ("COLLECTION_OBJECT_ID") DISABLE, 
	 CONSTRAINT "FK_CTNATURE_OF_ID" FOREIGN KEY ("NATURE_OF_ID")
	  REFERENCES "CTNATURE_OF_ID" ("NATURE_OF_ID") ENABLE, 
	 CONSTRAINT "FK_IDENT_TAXA_FORMULA" FOREIGN KEY ("TAXA_FORMULA")
	  REFERENCES "CTTAXA_FORMULA" ("TAXA_FORMULA") ENABLE, 
	 CONSTRAINT "FK_ID_COLL_OBJECT" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "COLL_OBJECT" ("COLLECTION_OBJECT_ID") ENABLE
   )  ENABLE ROW MOVEMENT 
  CREATE UNIQUE INDEX "PK_IDENT_ID" ON "IDENTIFICATION" ("IDENTIFICATION_ID") 
  
ALTER TABLE "IDENTIFICATION" ADD CONSTRAINT "PK_IDENT_ID" PRIMARY KEY ("IDENTIFICATION_ID")
  USING INDEX "PK_IDENT_ID"  ENABLE;
COMMENT ON COLUMN "IDENTIFICATION"."IDENTIFICATION_ID" IS 'Surrogate numeric primary key';
COMMENT ON COLUMN "IDENTIFICATION"."COLLECTION_OBJECT_ID" IS 'Collection object to which this identification applies';
COMMENT ON COLUMN "IDENTIFICATION"."DATE_MADE_DATE" IS 'Deprecated';
COMMENT ON COLUMN "IDENTIFICATION"."NATURE_OF_ID" IS 'Provenance of the identification.';
COMMENT ON COLUMN "IDENTIFICATION"."ACCEPTED_ID_FG" IS 'Flag indicating if the identification is the accepted identification for a collection object.';
COMMENT ON COLUMN "IDENTIFICATION"."IDENTIFICATION_REMARKS" IS 'Free text assertions concerning the identification.';
COMMENT ON COLUMN "IDENTIFICATION"."TAXA_FORMULA" IS 'Formula by which one or more taxon names are composed with each other and with optional additional text as part of the identification that is not part of the taxon name(s).   Allows expressions of uncertanty in identification and hybrids.  For each capital letter, A, B, etc. in the formula, there is expected to be a taxon_identification record linking this part of the formula to a taxon record.';
COMMENT ON COLUMN "IDENTIFICATION"."SCIENTIFIC_NAME" IS 'The text of the scientific name as used in the identification, Semiautomatic, composed from taxa_formula and the scientific names of any referenced taxa from the formula.';
COMMENT ON COLUMN "IDENTIFICATION"."PUBLICATION_ID" IS 'Sensu.  The publication that this use of the taxon name is in the sense of.    Links an identification to a taxon concept..';
COMMENT ON COLUMN "IDENTIFICATION"."SORT_ORDER" IS 'Sort order for identifications in addition to date of identification.';
COMMENT ON COLUMN "IDENTIFICATION"."STORED_AS_FG" IS 'Flag indicating that the collection object is stored under this name.';
COMMENT ON COLUMN "IDENTIFICATION"."MADE_DATE" IS 'Date the identification was made in ISO format.';
