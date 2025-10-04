
  CREATE TABLE "CF_TEMP_EDIT_PARTS" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"INSTITUTION_ACRONYM" VARCHAR2(60 CHAR), 
	"COLLECTION_CDE" VARCHAR2(10), 
	"OTHER_ID_TYPE" VARCHAR2(60 CHAR), 
	"OTHER_ID_NUMBER" VARCHAR2(60 CHAR), 
	"PART_NAME" VARCHAR2(60 CHAR), 
	"COLL_OBJ_DISPOSITION" VARCHAR2(40 CHAR), 
	"CONDITION" VARCHAR2(60 CHAR), 
	"LOT_COUNT" VARCHAR2(60 CHAR), 
	"LOT_COUNT_MODIFIER" VARCHAR2(5 CHAR), 
	"CURRENT_REMARKS" VARCHAR2(4000 CHAR), 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"PARENT_CONTAINER_ID" NUMBER, 
	"CONTAINER_UNIQUE_ID" VARCHAR2(255), 
	"CHANGE_CONTAINER_TYPE" VARCHAR2(255), 
	"USE_PART_ID" NUMBER, 
	"PRESERVE_METHOD" VARCHAR2(50 CHAR), 
	"APPEND_TO_REMARKS" VARCHAR2(2000 CHAR), 
	"CHANGED_DATE" VARCHAR2(10), 
	"NEW_PRESERVE_METHOD" VARCHAR2(50 CHAR), 
	"NEW_PART_NAME" VARCHAR2(60 CHAR), 
	"NEW_COLL_OBJ_DISPOSITION" VARCHAR2(40 CHAR), 
	"NEW_CONDITION" VARCHAR2(60 CHAR), 
	"NEW_LOT_COUNT" VARCHAR2(60 CHAR), 
	"NEW_LOT_COUNT_MODIFIER" VARCHAR2(5 CHAR), 
	"PART_ATT_NAME_1" VARCHAR2(255 CHAR), 
	"PART_ATT_VAL_1" VARCHAR2(255 CHAR), 
	"PART_ATT_UNITS_1" VARCHAR2(255 CHAR), 
	"PART_ATT_DETBY_1" VARCHAR2(255 CHAR), 
	"PART_ATT_MADEDATE_1" VARCHAR2(255 CHAR), 
	"PART_ATT_REM_1" VARCHAR2(4000 CHAR), 
	"PART_ATT_NAME_2" VARCHAR2(255 CHAR), 
	"PART_ATT_VAL_2" VARCHAR2(255 CHAR), 
	"PART_ATT_UNITS_2" VARCHAR2(255 CHAR), 
	"PART_ATT_DETBY_2" VARCHAR2(255 CHAR), 
	"PART_ATT_MADEDATE_2" VARCHAR2(255 CHAR), 
	"PART_ATT_REM_2" VARCHAR2(4000 CHAR), 
	"PART_ATT_NAME_3" VARCHAR2(1020), 
	"PART_ATT_VAL_3" VARCHAR2(1020), 
	"PART_ATT_UNITS_3" VARCHAR2(1020), 
	"PART_ATT_DETBY_3" VARCHAR2(1020), 
	"PART_ATT_MADEDATE_3" VARCHAR2(1020), 
	"PART_ATT_REM_3" VARCHAR2(4000), 
	"PART_ATT_NAME_4" VARCHAR2(1020), 
	"PART_ATT_VAL_4" VARCHAR2(1020), 
	"PART_ATT_UNITS_4" VARCHAR2(1020), 
	"PART_ATT_DETBY_4" VARCHAR2(1020), 
	"PART_ATT_MADEDATE_4" VARCHAR2(1020), 
	"PART_ATT_REM_4" VARCHAR2(4000), 
	"PART_ATT_NAME_5" VARCHAR2(1020), 
	"PART_ATT_VAL_5" VARCHAR2(1020), 
	"PART_ATT_UNITS_5" VARCHAR2(1020), 
	"PART_ATT_DETBY_5" VARCHAR2(1020), 
	"PART_ATT_MADEDATE_5" VARCHAR2(1020), 
	"PART_ATT_REM_5" VARCHAR2(4000), 
	"PART_ATT_NAME_6" VARCHAR2(1020), 
	"PART_ATT_VAL_6" VARCHAR2(1020), 
	"PART_ATT_UNITS_6" VARCHAR2(1020), 
	"PART_ATT_DETBY_6" VARCHAR2(1020), 
	"PART_ATT_MADEDATE_6" VARCHAR2(1020), 
	"PART_ATT_REM_6" VARCHAR2(4000), 
	"USERNAME" VARCHAR2(1020), 
	"STATUS" VARCHAR2(4000), 
	"PART_COLLECTION_OBJECT_ID" NUMBER, 
	 CONSTRAINT "CF_TEMP_EDIT_PARTS_PK" PRIMARY KEY ("KEY")
  USING INDEX  ENABLE
   ) ;
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."OTHER_ID_TYPE" IS 'Required; Controlled vocabulary, type of identifier for the cataloged item, use "catalog number" with catalog number in other_id_number.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."OTHER_ID_NUMBER" IS 'Required; Free text. Identifies the cataloged item for the part to edit.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_NAME" IS 'Required if part_collection_object_id is not specified; Current Part Name. Identifies the part to edit.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."COLL_OBJ_DISPOSITION" IS 'Required if part_collection_object_id is not specified; Current value of the disposition of the part.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."CONDITION" IS 'Required if part_collection_object_id is not specified; Current condition of the part.  Identifies the part to edit.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."LOT_COUNT" IS 'Required if part_collection_object_id is not specified; Current number of specimens in the part. Identifies the part to edit.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."LOT_COUNT_MODIFIER" IS 'Required (but may be empty) if part_collection_object_id is not specified: Current value of the modifier on the count; e.g., >, ~, <. Identifies the part to edit.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."CURRENT_REMARKS" IS 'Required (but may be empty) if part_collection_object_id is not specified: The current part remarks.  Identifies the part to edit, must be used if part name, condition, lot count, and preserve method do not uniquely identify a part within the cataloged item..';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."COLLECTION_OBJECT_ID" IS 'Added in validation step, ID for the cataloged item determined from collection_cde, other_id_type, and other_id_number.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PARENT_CONTAINER_ID" IS 'ID for the parent container into which the container_unique_id is to be placed.  ';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."CONTAINER_UNIQUE_ID" IS 'Current Unique container ID for the part.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."USE_PART_ID" IS 'Deprecated';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PRESERVE_METHOD" IS 'Required if part_collection_object_id is not specified; current preservation method.  Identifies the part to modiify';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."APPEND_TO_REMARKS" IS 'Anything in this field will be appended to the current part remarks. It will be automatically separated by a semicolon from any existing remarks.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."CHANGED_DATE" IS 'Include if any NEW_ value is specfied to change the part, and the date of change is different than today (Format = YYYY-MM-DD), leave blank for the current date.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."NEW_PRESERVE_METHOD" IS 'The value in this field will replace the current preserve method for this part.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."NEW_PART_NAME" IS 'The value in this field will replace the current preserve method for this part.  ';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."NEW_COLL_OBJ_DISPOSITION" IS 'The value in this field will replace the current disposition of the part. Must match controlled vocabulary';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."NEW_CONDITION" IS 'The value in this field will replace the current preserve method for this part.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."NEW_LOT_COUNT" IS 'The value in this field will replace the current preserve method for this part.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."NEW_LOT_COUNT_MODIFIER" IS 'The value in this field will replace the current preserve method for this part.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_NAME_1" IS 'First attribute to add. Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_VAL_1" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_UNITS_1" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_DETBY_1" IS 'Required when adding part attribute. Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_MADEDATE_1" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_REM_1" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_NAME_2" IS 'Second attribute to add. Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_VAL_2" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_UNITS_2" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_DETBY_2" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_MADEDATE_2" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_REM_2" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_NAME_3" IS 'Third attribute to add. Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_VAL_3" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_UNITS_3" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_DETBY_3" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_MADEDATE_3" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_REM_3" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_NAME_4" IS 'Fourth attribute to add. Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_VAL_4" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_UNITS_4" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_DETBY_4" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_MADEDATE_4" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_REM_4" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_NAME_5" IS 'Fifth attribute to add. Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_VAL_5" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_UNITS_5" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_DETBY_5" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_MADEDATE_5" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_REM_5" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_NAME_6" IS 'Sixth attribute to add. Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_VAL_6" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_UNITS_6" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_DETBY_6" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_MADEDATE_6" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_ATT_REM_6" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."USERNAME" IS 'Username for the user who uploaded a set of data.  Each user can work with one part edit bulkload at a time.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."STATUS" IS 'Validation status or Error message, added automatically in the validation step.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."PART_COLLECTION_OBJECT_ID" IS 'Collection_object_id for the part to be modified.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."INSTITUTION_ACRONYM" IS 'Required; Should be "MCZ".  Identifies the part to edit.';
COMMENT ON COLUMN "CF_TEMP_EDIT_PARTS"."COLLECTION_CDE" IS 'Required; Collection or department abbreviation. Identifies the part to edit.';
