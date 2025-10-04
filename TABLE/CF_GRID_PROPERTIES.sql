
  CREATE TABLE "CF_GRID_PROPERTIES" 
   (	"CF_GRID_COLUMNS_VISIBILITY_ID" NUMBER NOT NULL ENABLE, 
	"PAGE_FILE_PATH" VARCHAR2(255) NOT NULL ENABLE, 
	"USERNAME" VARCHAR2(30) NOT NULL ENABLE, 
	"LABEL" VARCHAR2(20) DEFAULT 'Default' NOT NULL ENABLE, 
	"COLUMNHIDDENSETTINGS" CLOB DEFAULT '{}' NOT NULL ENABLE, 
	"COLUMN_ORDER" CLOB DEFAULT '[]' NOT NULL ENABLE
   ) 
  CREATE UNIQUE INDEX "IDX_CF_GRID_PROPERTIES_PK" ON "CF_GRID_PROPERTIES" ("CF_GRID_COLUMNS_VISIBILITY_ID") 
  
ALTER TABLE "CF_GRID_PROPERTIES" ADD CONSTRAINT "CF_GRID_PROPERTIES_PK" PRIMARY KEY ("CF_GRID_COLUMNS_VISIBILITY_ID")
  USING INDEX "IDX_CF_GRID_PROPERTIES_PK"  ENABLE;
COMMENT ON TABLE "CF_GRID_PROPERTIES" IS 'Supports persistence of choice of visible columns on a grid by storing a the serialization of hidden column properties for a jqxGrid by user on a page.  Extensible to storage of additional properties.';
COMMENT ON COLUMN "CF_GRID_PROPERTIES"."CF_GRID_COLUMNS_VISIBILITY_ID" IS 'surrogate numeric primary key';
COMMENT ON COLUMN "CF_GRID_PROPERTIES"."PAGE_FILE_PATH" IS 'filename and path from root for the coldfusion page to which this column visibility applies.';
COMMENT ON COLUMN "CF_GRID_PROPERTIES"."USERNAME" IS 'the user for which this column visibilities applies on this page.';
COMMENT ON COLUMN "CF_GRID_PROPERTIES"."LABEL" IS 'Label for the column properties set for a user for a page, enables more than one named configuration to be stored for a page.';
COMMENT ON COLUMN "CF_GRID_PROPERTIES"."COLUMNHIDDENSETTINGS" IS 'json serialization of window.columnHiddenSettings, key value pairs where key is the datafield and value is the hidden column property for that datafield';
COMMENT ON COLUMN "CF_GRID_PROPERTIES"."COLUMN_ORDER" IS 'Json serialization of a map of column datafield names and their column order, for persisting column ordering of a grid.';
