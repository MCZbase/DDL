
  CREATE TABLE "CF_TEMP_ATTRIBUTES" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"OTHER_ID_TYPE" VARCHAR2(60 CHAR), 
	"OTHER_ID_NUMBER" VARCHAR2(60 CHAR), 
	"ATTRIBUTE" VARCHAR2(60 CHAR), 
	"ATTRIBUTE_VALUE" VARCHAR2(4000), 
	"ATTRIBUTE_UNITS" VARCHAR2(60 CHAR), 
	"ATTRIBUTE_DATE" VARCHAR2(60 CHAR), 
	"ATTRIBUTE_METH" VARCHAR2(255 CHAR), 
	"DETERMINER" VARCHAR2(60 CHAR), 
	"REMARKS" VARCHAR2(255 CHAR), 
	"COLLECTION_CDE" VARCHAR2(10), 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"INSTITUTION_ACRONYM" VARCHAR2(20 CHAR), 
	"DETERMINED_BY_AGENT_ID" NUMBER, 
	"STATUS" VARCHAR2(4000), 
	"USERNAME" VARCHAR2(255)
   ) ;
COMMENT ON TABLE "CF_TEMP_ATTRIBUTES" IS 'Table to support bulkload of specimen attributes.  Holds values read from bulkload spreadsheet prior to validation and validation results.';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."KEY" IS 'Semi-automatic surrogate key';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."OTHER_ID_TYPE" IS 'Identification of how the other_id_number relates to a key value for cataloged item';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."OTHER_ID_NUMBER" IS 'Identifier for the cataloged item to which the attribute applies';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."ATTRIBUTE" IS 'The attribute type';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."ATTRIBUTE_VALUE" IS 'The value of the attribute';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."ATTRIBUTE_UNITS" IS 'Units for the attribute, if any';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."ATTRIBUTE_DATE" IS 'Determination date for the attribute value';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."ATTRIBUTE_METH" IS 'Method by which the attribute value was determined';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."DETERMINER" IS 'Preferred name of the agent who determined the attribute value';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."REMARKS" IS 'Attribute remarks';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."COLLECTION_CDE" IS 'Collection code for the cataloged item';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."COLLECTION_OBJECT_ID" IS 'Semi-automatic the collection_object_id determined from collection_cde, other_id_type, and other_id_value.';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."INSTITUTION_ACRONYM" IS 'The instutition code for the cataloged item';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."DETERMINED_BY_AGENT_ID" IS 'Semi-automatic, the agent_id for the determiner';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."STATUS" IS 'Semi-automatic, a status message reporting on load blocking data qualitiy issues identified with this temporary record';
COMMENT ON COLUMN "CF_TEMP_ATTRIBUTES"."USERNAME" IS 'The user who created these temporary rows';
