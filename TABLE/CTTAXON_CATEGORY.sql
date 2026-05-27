
  CREATE TABLE "CTTAXON_CATEGORY" 
   (	"TAXON_CATEGORY" VARCHAR2(255) NOT NULL ENABLE, 
	"CATEGORY_TYPE" VARCHAR2(50) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000), 
	"HIDDEN_FG" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "CTTAXON_CATEGORY_PK" PRIMARY KEY ("TAXON_CATEGORY")
  USING INDEX  ENABLE
   ) ;
COMMENT ON TABLE "CTTAXON_CATEGORY" IS 'Controled vocabulary for taxon_category values and their types.';
COMMENT ON COLUMN "CTTAXON_CATEGORY"."HIDDEN_FG" IS 'Visibility of the taxon category, 0 for public, 1 for internal users only.';
COMMENT ON COLUMN "CTTAXON_CATEGORY"."TAXON_CATEGORY" IS 'Controled vocabulary for taxon_category.taxon_category, formal or informal categories for taxon name records.';
COMMENT ON COLUMN "CTTAXON_CATEGORY"."CATEGORY_TYPE" IS 'Typing for taxon_category values, values like required botanical, zoological, biological, grade, grant, etc.';
COMMENT ON COLUMN "CTTAXON_CATEGORY"."DESCRIPTION" IS 'Free text description for the category.';
