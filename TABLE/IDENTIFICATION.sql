
  CREATE TABLE "IDENTIFICATION" 
   (	"IDENTIFICATION_ID" NUMBER NOT NULL ENABLE, 
	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"DATE_MADE_DATE" DATE, 
	"NATURE_OF_ID" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"ACCEPTED_ID_FG" NUMBER NOT NULL ENABLE, 
	"IDENTIFICATION_REMARKS" VARCHAR2(4000 CHAR), 
	"TAXA_FORMULA" VARCHAR2(25 CHAR) NOT NULL ENABLE, 
	"SCIENTIFIC_NAME" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"PUBLICATION_ID" NUMBER, 
	"SORT_ORDER" NUMBER(2,0), 
	"STORED_AS_FG" NUMBER(1,0) DEFAULT 0, 
	"MADE_DATE" VARCHAR2(22 CHAR), 
	 CONSTRAINT "PK_IDENT_ID" PRIMARY KEY ("IDENTIFICATION_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_IDENTIFICATION_CATITEM" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "CATALOGED_ITEM" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "FK_CTNATURE_OF_ID" FOREIGN KEY ("NATURE_OF_ID")
	  REFERENCES "CTNATURE_OF_ID" ("NATURE_OF_ID") ENABLE
   )  ENABLE ROW MOVEMENT 