
  CREATE TABLE "CF_TEMP_PARTS" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"INSTITUTION_ACRONYM" VARCHAR2(60 CHAR), 
	"COLLECTION_CDE" VARCHAR2(10), 
	"OTHER_ID_TYPE" VARCHAR2(60 CHAR), 
	"OTHER_ID_NUMBER" VARCHAR2(60 CHAR), 
	"PART_NAME" VARCHAR2(60 CHAR), 
	"CONDITION" VARCHAR2(60 CHAR), 
	"LOT_COUNT" VARCHAR2(60 CHAR), 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"PARENT_CONTAINER_ID" NUMBER, 
	"CONTAINER_UNIQUE_ID" VARCHAR2(255), 
	"PRESERVE_METHOD" VARCHAR2(50 CHAR), 
	"LOT_COUNT_MODIFIER" VARCHAR2(5 CHAR), 
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
	"COLL_OBJ_DISPOSITION" VARCHAR2(1020), 
	"STATUS" VARCHAR2(4000), 
	"PART_REMARKS" VARCHAR2(2000)
   ) ;
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_REM_1" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_NAME_2" IS 'Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_VAL_2" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_UNITS_2" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_DETBY_2" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_MADEDATE_2" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_REM_2" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_NAME_3" IS 'Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_VAL_3" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_UNITS_3" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_DETBY_3" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_MADEDATE_3" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_REM_3" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_NAME_4" IS 'Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_VAL_4" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_UNITS_4" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_DETBY_4" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_MADEDATE_4" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_REM_4" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_NAME_5" IS 'Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_VAL_5" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_UNITS_5" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_DETBY_5" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_MADEDATE_5" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_REM_5" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_NAME_6" IS 'Part attribute name is controlled vocabulary determined by collections.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_VAL_6" IS 'Part value could be controlled vocabulary; depends on part attribute name.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_UNITS_6" IS 'Part attribute units come from controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_DETBY_6" IS 'Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_MADEDATE_6" IS 'Part attribute made date; YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_REM_6" IS 'Part attribute remarks.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."USERNAME" IS 'The person who is uploading these parts.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."COLL_OBJ_DISPOSITION" IS 'REQUIRED; controlled vocabulary; disposition of part.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."STATUS" IS 'Error for the upload will appear here.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_REMARKS" IS 'Remarks for the new part.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."KEY" IS 'Surrogate numeric primary key';
COMMENT ON COLUMN "CF_TEMP_PARTS"."INSTITUTION_ACRONYM" IS 'REQUIRED for adding new parts; Should be "MCZ".';
COMMENT ON COLUMN "CF_TEMP_PARTS"."COLLECTION_CDE" IS 'REQUIRED for adding new parts; Collection or department abbreviation.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."OTHER_ID_TYPE" IS 'REQUIRED for adding new parts; Controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."OTHER_ID_NUMBER" IS 'REQUIRED for adding new parts; Free text.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_NAME" IS 'REQUIRED for adding new parts; Controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."CONDITION" IS 'REQUIRED for adding parts; Condition of the part.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."LOT_COUNT" IS 'REQUIRED for adding new parts; Add a 1 or other number of objects for the part/lot.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."COLLECTION_OBJECT_ID" IS 'ID created from collection_cde, other_id_type, and other_id_number.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PARENT_CONTAINER_ID" IS 'Automatic.  Lookup for ID for the parent container based on the container_unique_id.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."CONTAINER_UNIQUE_ID" IS 'Manual.  Unique container ID for the part to be placed in; it must already be in MCZbase.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PRESERVE_METHOD" IS 'REQUIRED;  preservation method uses controlled vocabulary by collection.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."LOT_COUNT_MODIFIER" IS 'Use operator to modify count; e.g., >, ~, <.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_NAME_1" IS 'Part attribute name is controlled vocabulary determined by collections, see SPECPART_ATTRIBUTE_TYPE.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_VAL_1" IS 'Part value could be controlled vocabulary; depends on part attribute name, see CTSPEC_PART_ATT_ATT.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_UNITS_1" IS 'Part attribute units come from controlled vocabulary, see CTSPEC_PART_ATT_ATT.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_DETBY_1" IS 'Required when adding part attribute. Preferred name of person determining the attribute.';
COMMENT ON COLUMN "CF_TEMP_PARTS"."PART_ATT_MADEDATE_1" IS 'Part attribute made date; YYYY-MM-DD.';
