
  CREATE TABLE "CF_TEMP_CITATION" 
   (	"KEY" NUMBER, 
	"PUBLICATION_TITLE" VARCHAR2(4000 CHAR), 
	"PUBLICATION_ID" NUMBER, 
	"INSTITUTION_ACRONYM" VARCHAR2(6 CHAR), 
	"COLLECTION_CDE" VARCHAR2(10), 
	"OTHER_ID_TYPE" VARCHAR2(60 CHAR), 
	"OTHER_ID_NUMBER" VARCHAR2(60 CHAR), 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"CITED_SCIENTIFIC_NAME" VARCHAR2(60 CHAR), 
	"CITED_TAXON_NAME_ID" NUMBER, 
	"OCCURS_PAGE_NUMBER" NUMBER, 
	"TYPE_STATUS" VARCHAR2(60 CHAR), 
	"CITATION_REMARKS" VARCHAR2(4000), 
	"STATUS" VARCHAR2(4000), 
	"CITATION_PAGE_URI" VARCHAR2(255 CHAR), 
	"USERNAME" VARCHAR2(1020)
   ) ;
COMMENT ON COLUMN "CF_TEMP_CITATION"."PUBLICATION_TITLE" IS 'Title of publication.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."PUBLICATION_ID" IS 'Required; ID of the publication; Find through an MCZbase publication search.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."INSTITUTION_ACRONYM" IS 'Required; Should be "MCZ" at this time.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."COLLECTION_CDE" IS 'Required; Collection or Department where the object is stored/curated.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."OTHER_ID_TYPE" IS 'Required; Use "catalog number" or other_id_type used by a collection.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."OTHER_ID_NUMBER" IS 'Required; Either existing catalog number or other number.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."COLLECTION_OBJECT_ID" IS 'Internal number retrieved from collection_cde, other_id_type, and other_id_number';
COMMENT ON COLUMN "CF_TEMP_CITATION"."CITED_SCIENTIFIC_NAME" IS 'Required; Scientific name must already existing in MCZbase. Search taxonomy.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."CITED_TAXON_NAME_ID" IS 'ID for the scientific name cited.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."OCCURS_PAGE_NUMBER" IS 'First page number where the collection object is mentioned.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."TYPE_STATUS" IS 'Required; Uses controlled vocabulary (citation_type_status).';
COMMENT ON COLUMN "CF_TEMP_CITATION"."CITATION_REMARKS" IS 'Remarks related to the citation.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."STATUS" IS 'Field where error will be displayed.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."CITATION_PAGE_URI" IS 'Page link where the first mention of the collection object occurs in the publication.';
COMMENT ON COLUMN "CF_TEMP_CITATION"."USERNAME" IS 'The user who created these temporary rows.';
