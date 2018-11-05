
  CREATE TABLE "CF_TEMP_TAXONOMY" 
   (	"KEY" NUMBER, 
	"FORCE_LOAD" NUMBER, 
	"STATUS" VARCHAR2(255 CHAR), 
	"TAXON_NAME_ID" NUMBER, 
	"PHYLCLASS" VARCHAR2(40), 
	"PHYLORDER" VARCHAR2(30 CHAR), 
	"SUBORDER" VARCHAR2(30 CHAR), 
	"FAMILY" VARCHAR2(50 CHAR), 
	"SUBFAMILY" VARCHAR2(30 CHAR), 
	"GENUS" VARCHAR2(30 CHAR), 
	"SUBGENUS" VARCHAR2(20 CHAR), 
	"SPECIES" VARCHAR2(40 CHAR), 
	"SUBSPECIES" VARCHAR2(40 CHAR), 
	"VALID_CATALOG_TERM_FG" NUMBER NOT NULL ENABLE, 
	"SOURCE_AUTHORITY" VARCHAR2(45 CHAR) NOT NULL ENABLE, 
	"SCIENTIFIC_NAME" VARCHAR2(255 CHAR), 
	"AUTHOR_TEXT" VARCHAR2(255 CHAR), 
	"TRIBE" VARCHAR2(30 CHAR), 
	"INFRASPECIFIC_RANK" VARCHAR2(20 CHAR), 
	"TAXON_REMARKS" VARCHAR2(4000), 
	"PHYLUM" VARCHAR2(30 CHAR), 
	"KINGDOM" VARCHAR2(255 CHAR), 
	"NOMENCLATURAL_CODE" VARCHAR2(255 CHAR), 
	"INFRASPECIFIC_AUTHOR" VARCHAR2(255 CHAR), 
	"SUBCLASS" VARCHAR2(50 CHAR), 
	"DIVISION" VARCHAR2(50 CHAR), 
	"SUPERFAMILY" VARCHAR2(50 CHAR), 
	"TAXON_STATUS" VARCHAR2(60 CHAR), 
	"SUBPHYLUM" VARCHAR2(50), 
	"GUID" VARCHAR2(255), 
	"INFRACLASS" VARCHAR2(100), 
	"SUBSECTION" VARCHAR2(50), 
	"INFRAORDER" VARCHAR2(100), 
	"SUPERORDER" VARCHAR2(100)
   ) 