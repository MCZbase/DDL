
  CREATE TABLE "CF_SPEC_SEARCH_COLS" 
   (	"ID" NUMBER NOT NULL ENABLE, 
	"TABLE_NAME" VARCHAR2(30), 
	"TABLE_ALIAS" VARCHAR2(30), 
	"COLUMN_NAME" VARCHAR2(30), 
	"COLUMN_ALIAS" VARCHAR2(50), 
	"SEARCH_CATEGORY" VARCHAR2(30), 
	"DATA_TYPE" VARCHAR2(106), 
	"DATA_LENGTH" NUMBER, 
	"LABEL" VARCHAR2(255) DEFAULT 'New Field', 
	"ACCESS_ROLE" VARCHAR2(20) DEFAULT 'HIDE' NOT NULL ENABLE, 
	"UI_FUNCTION" VARCHAR2(900), 
	"EXAMPLE_VALUES" VARCHAR2(255), 
	"DESCRIPTION" VARCHAR2(900), 
	 CONSTRAINT "CF_SPEC_SEARCH_COLS_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."LABEL" IS 'human readable labels';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."ACCESS_ROLE" IS 'User role needed to see this row when searching in the search builder.';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."UI_FUNCTION" IS 'Name of Function (such as an autocomplete builder) to apply to the input on the search builder form';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."EXAMPLE_VALUES" IS 'Example values of data to enter for search';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."DESCRIPTION" IS 'Human readable description of how to use this term in a search.';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."TABLE_ALIAS" IS 'Table alias to use in query';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."COLUMN_NAME" IS 'Column name to use in query';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."COLUMN_ALIAS" IS 'Unique alias for this search column (row in this table)';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."SEARCH_CATEGORY" IS 'Category for grouping this record in the user interface.';
COMMENT ON COLUMN "CF_SPEC_SEARCH_COLS"."DATA_TYPE" IS 'Data type for the field found by table_name.column_name when constructing queries.';
