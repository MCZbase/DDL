
  CREATE TABLE "CF_TEMP_OIDS" 
   (	"KEY" NUMBER, 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"COLLECTION_CDE" VARCHAR2(10), 
	"INSTITUTION_ACRONYM" VARCHAR2(6 CHAR), 
	"EXISTING_OTHER_ID_TYPE" VARCHAR2(60 CHAR), 
	"EXISTING_OTHER_ID_NUMBER" VARCHAR2(60 CHAR), 
	"NEW_OTHER_ID_TYPE" VARCHAR2(60 CHAR), 
	"NEW_OTHER_ID_NUMBER" VARCHAR2(60 CHAR), 
	"STATUS" VARCHAR2(4000), 
	"USERNAME" VARCHAR2(1020)
   ) ;
COMMENT ON COLUMN "CF_TEMP_OIDS"."COLLECTION_OBJECT_ID" IS 'Formed from the existing_other_id_type and existing_other_id_number. ';
COMMENT ON COLUMN "CF_TEMP_OIDS"."COLLECTION_CDE" IS 'Collection/department where the collection object is stored.';
COMMENT ON COLUMN "CF_TEMP_OIDS"."INSTITUTION_ACRONYM" IS 'Should be "MCZ".';
COMMENT ON COLUMN "CF_TEMP_OIDS"."EXISTING_OTHER_ID_TYPE" IS 'other_id_type that will find the record.';
COMMENT ON COLUMN "CF_TEMP_OIDS"."EXISTING_OTHER_ID_NUMBER" IS 'other_id_number that will find the correct record.';
COMMENT ON COLUMN "CF_TEMP_OIDS"."NEW_OTHER_ID_TYPE" IS 'new_other_id_type; controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_OIDS"."NEW_OTHER_ID_NUMBER" IS 'new_other_id_number; free text.';
COMMENT ON COLUMN "CF_TEMP_OIDS"."STATUS" IS 'Field containing the validation errors.';
COMMENT ON COLUMN "CF_TEMP_OIDS"."USERNAME" IS 'The person who created these temporary rows';
