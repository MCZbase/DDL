
  CREATE TABLE "TAXONOMY_ARCHIVE" 
   (	"TAXON_NAME_ID" NUMBER NOT NULL ENABLE, 
	"PHYLCLASS" VARCHAR2(40 CHAR), 
	"PHYLORDER" VARCHAR2(30 CHAR), 
	"SUBORDER" VARCHAR2(30 CHAR), 
	"FAMILY" VARCHAR2(100), 
	"SUBFAMILY" VARCHAR2(50 CHAR), 
	"GENUS" VARCHAR2(50), 
	"SUBGENUS" VARCHAR2(20 CHAR), 
	"SPECIES" VARCHAR2(40 CHAR), 
	"SUBSPECIES" VARCHAR2(40 CHAR), 
	"VALID_CATALOG_TERM_FG" NUMBER NOT NULL ENABLE, 
	"SOURCE_AUTHORITY" VARCHAR2(45 CHAR) NOT NULL ENABLE, 
	"FULL_TAXON_NAME" VARCHAR2(240 CHAR), 
	"SCIENTIFIC_NAME" VARCHAR2(110 CHAR), 
	"AUTHOR_TEXT" VARCHAR2(100 CHAR), 
	"TRIBE" VARCHAR2(30 CHAR), 
	"INFRASPECIFIC_RANK" VARCHAR2(10 CHAR), 
	"TAXON_REMARKS" VARCHAR2(4000 CHAR), 
	"PHYLUM" VARCHAR2(30 CHAR), 
	"SUPERFAMILY" VARCHAR2(50 CHAR), 
	"SUBPHYLUM" VARCHAR2(50 CHAR), 
	"SUBCLASS" VARCHAR2(50 CHAR), 
	"KINGDOM" VARCHAR2(255 CHAR), 
	"NOMENCLATURAL_CODE" VARCHAR2(255 CHAR), 
	"INFRASPECIFIC_AUTHOR" VARCHAR2(255 CHAR), 
	"WHEN" DATE NOT NULL ENABLE, 
	"WHO" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"SCI_NAME_NO_IRANK" VARCHAR2(255 CHAR), 
	"SCI_NAME_WITH_AUTHS" VARCHAR2(255 CHAR), 
	"INFRAORDER" VARCHAR2(100), 
	"SUPERORDER" VARCHAR2(100), 
	"DIVISION" VARCHAR2(100), 
	"SUBDIVISION" VARCHAR2(100), 
	"SUPERCLASS" VARCHAR2(100), 
	"INFRACLASS" VARCHAR2(100)
   )  ENABLE ROW MOVEMENT 