
  CREATE TABLE "CF_TEMP_BL_RELATIONS" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"INSTITUTION_ACRONYM" VARCHAR2(6 CHAR) NOT NULL ENABLE, 
	"COLLECTION_CDE" VARCHAR2(10) NOT NULL ENABLE, 
	"OTHER_ID_TYPE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"OTHER_ID_VALUE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"RELATIONSHIP" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"RELATED_INSTITUTION_ACRONYM" VARCHAR2(6 CHAR) NOT NULL ENABLE, 
	"RELATED_COLLECTION_CDE" VARCHAR2(6 CHAR) NOT NULL ENABLE, 
	"RELATED_OTHER_ID_TYPE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"RELATED_OTHER_ID_VALUE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"RELATED_COLLECTION_OBJECT_ID" NUMBER, 
	"STATUS" VARCHAR2(4000 CHAR), 
	"USERNAME" VARCHAR2(1020), 
	"BIOL_INDIV_RELATION_REMARKS" VARCHAR2(4000)
   ) ;
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."KEY" IS 'Surrogate numeric primary key';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."INSTITUTION_ACRONYM" IS 'Institution for the first collection object. Should be "MCZ"';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."COLLECTION_CDE" IS 'Collection or Department abbreviation for the first collection object. Controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."OTHER_ID_TYPE" IS 'The other_id_type can point to a series per collection that identifies the collection object. Use this controlled vocabulary CTCOLL_OTHER_ID_TYPE, or use ''catalog number'' to supply a catalog number in other_id_value.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."OTHER_ID_VALUE" IS 'Number that goes with other_id_type;must exist in MCZbase already.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."RELATIONSHIP" IS 'The type of relationship between the two cataloged items.  Controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."RELATED_INSTITUTION_ACRONYM" IS 'Institution code for the related cataloged item. Usually MCZ, but could be acronym for another institution.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."RELATED_COLLECTION_CDE" IS 'Collection_cde for the related object.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."RELATED_OTHER_ID_TYPE" IS 'Other_id_type for the related object.  Use ''catalog number'' to match with related_other_id_value of catalog number.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."RELATED_OTHER_ID_VALUE" IS 'Other_id_number for the related object.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."COLLECTION_OBJECT_ID" IS 'Primary key value for the cataloged item looked up from collection_cde, other_id_type and other_id_number.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."RELATED_COLLECTION_OBJECT_ID" IS 'Primary key value for the related cataloged item, looked up from related collection_cde, other_id_type and other_id_number.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."STATUS" IS 'Error messages will appear in this column.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."USERNAME" IS 'The user who created these temporary rows.';
COMMENT ON COLUMN "CF_TEMP_BL_RELATIONS"."BIOL_INDIV_RELATION_REMARKS" IS 'Remarks about the biological relationship.';
