
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
   ) 