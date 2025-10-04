
  CREATE TABLE "CF_TEMP_ID" 
   (	"KEY" NUMBER, 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"COLLECTION_CDE" VARCHAR2(10), 
	"INSTITUTION_ACRONYM" VARCHAR2(6 CHAR), 
	"OTHER_ID_TYPE" VARCHAR2(60 CHAR), 
	"OTHER_ID_NUMBER" VARCHAR2(60 CHAR), 
	"SCIENTIFIC_NAME" VARCHAR2(255 CHAR), 
	"MADE_DATE" VARCHAR2(22 CHAR), 
	"NATURE_OF_ID" VARCHAR2(30 CHAR), 
	"ACCEPTED_ID_FG" NUMBER(1,0), 
	"IDENTIFICATION_REMARKS" VARCHAR2(255 CHAR), 
	"AGENT_1" VARCHAR2(60 CHAR), 
	"AGENT_2" VARCHAR2(60 CHAR), 
	"STATUS" VARCHAR2(4000), 
	"TAXON_NAME_ID" NUMBER, 
	"TAXA_FORMULA" VARCHAR2(25), 
	"AGENT_1_ID" NUMBER, 
	"AGENT_2_ID" NUMBER, 
	"STORED_AS_FG" NUMBER(1,0), 
	"USERNAME" VARCHAR2(1020), 
	"PUBLICATION_ID" VARCHAR2(1020)
   ) ;
COMMENT ON COLUMN "CF_TEMP_ID"."COLLECTION_OBJECT_ID" IS 'Number formed from other_id_type and other_id_number of a dept.';
COMMENT ON COLUMN "CF_TEMP_ID"."COLLECTION_CDE" IS 'Collection or department abbreviation.';
COMMENT ON COLUMN "CF_TEMP_ID"."INSTITUTION_ACRONYM" IS 'Should be "MCZ".';
COMMENT ON COLUMN "CF_TEMP_ID"."OTHER_ID_TYPE" IS 'Type of other id for matching the cataloged item, use catalog number to match on catalog number or other id Controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_ID"."OTHER_ID_NUMBER" IS 'Free text number to identify the cataloged item.';
COMMENT ON COLUMN "CF_TEMP_ID"."SCIENTIFIC_NAME" IS 'Must match scientific_name in taxonomy table.';
COMMENT ON COLUMN "CF_TEMP_ID"."MADE_DATE" IS 'Date the identification was made, use the format YYYY-MM-DD.';
COMMENT ON COLUMN "CF_TEMP_ID"."NATURE_OF_ID" IS 'Nature of the identification, Controlled vocabulary.';
COMMENT ON COLUMN "CF_TEMP_ID"."ACCEPTED_ID_FG" IS 'To put the ID at the top of the record as "current", use "1". ';
COMMENT ON COLUMN "CF_TEMP_ID"."IDENTIFICATION_REMARKS" IS 'Remarks related to the identification.';
COMMENT ON COLUMN "CF_TEMP_ID"."AGENT_1" IS 'First determiner of identification; use preferred name.';
COMMENT ON COLUMN "CF_TEMP_ID"."AGENT_2" IS 'Second determiner of identification; use preferred name.';
COMMENT ON COLUMN "CF_TEMP_ID"."STATUS" IS 'Field for error messages after validation step.';
COMMENT ON COLUMN "CF_TEMP_ID"."TAXON_NAME_ID" IS 'Will be added from the scientific_name.';
COMMENT ON COLUMN "CF_TEMP_ID"."TAXA_FORMULA" IS 'Formula for text added to the scientific name in the identification, e.g. A sp.';
COMMENT ON COLUMN "CF_TEMP_ID"."AGENT_1_ID" IS 'Agent ID for the first determiner. Will be added from Agent_1.';
COMMENT ON COLUMN "CF_TEMP_ID"."AGENT_2_ID" IS 'Agent ID for the second determiner.  Will be added from Agent_2.';
COMMENT ON COLUMN "CF_TEMP_ID"."STORED_AS_FG" IS 'For specimens stored as a name that is not the current name; use 1, 0, or leave blank. ';
COMMENT ON COLUMN "CF_TEMP_ID"."USERNAME" IS 'The person adding these rows to the temp table.';
COMMENT ON COLUMN "CF_TEMP_ID"."PUBLICATION_ID" IS 'Numeric key for the publication for the identification.  Find with a publication search in MCZbase.';
