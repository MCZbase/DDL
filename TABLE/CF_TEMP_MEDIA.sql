
  CREATE TABLE "CF_TEMP_MEDIA" 
   (	"KEY" NUMBER, 
	"MEDIA_URI" VARCHAR2(255 CHAR), 
	"MIME_TYPE" VARCHAR2(255 CHAR), 
	"MEDIA_TYPE" VARCHAR2(255 CHAR), 
	"PREVIEW_URI" VARCHAR2(255 CHAR), 
	"STATUS" VARCHAR2(4000 CHAR), 
	"MEDIA_LICENSE_ID" NUMBER(22,0), 
	"MASK_MEDIA" NUMBER(1,0), 
	"USERNAME" VARCHAR2(1020), 
	"HEIGHT" VARCHAR2(255), 
	"WIDTH" VARCHAR2(255), 
	"MADE_DATE" VARCHAR2(10), 
	"SUBJECT" VARCHAR2(255), 
	"DESCRIPTION" VARCHAR2(4000), 
	"MEDIA_LABEL_1" VARCHAR2(255), 
	"LABEL_VALUE_1" VARCHAR2(255), 
	"MEDIA_LABEL_2" VARCHAR2(255), 
	"LABEL_VALUE_2" VARCHAR2(255), 
	"MEDIA_LABEL_3" VARCHAR2(255), 
	"LABEL_VALUE_3" VARCHAR2(255), 
	"MEDIA_LABEL_4" VARCHAR2(255), 
	"LABEL_VALUE_4" VARCHAR2(255), 
	"MEDIA_LABEL_5" VARCHAR2(255), 
	"LABEL_VALUE_5" VARCHAR2(255), 
	"MEDIA_LABEL_6" VARCHAR2(255), 
	"LABEL_VALUE_6" VARCHAR2(255), 
	"MEDIA_LABEL_7" VARCHAR2(255), 
	"LABEL_VALUE_7" VARCHAR2(255), 
	"MEDIA_LABEL_8" VARCHAR2(255), 
	"LABEL_VALUE_8" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_1" VARCHAR2(255), 
	"MEDIA_RELATED_TO_1" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_2" VARCHAR2(255), 
	"MEDIA_RELATED_TO_2" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_3" VARCHAR2(255), 
	"MEDIA_RELATED_TO_3" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_4" VARCHAR2(255), 
	"MEDIA_RELATED_TO_4" VARCHAR2(255), 
	"MD5HASH" VARCHAR2(255), 
	"CREATED_BY_AGENT_ID" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_5" VARCHAR2(255), 
	"MEDIA_RELATED_TO_5" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_6" VARCHAR2(255), 
	"MEDIA_RELATED_TO_6" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_7" VARCHAR2(255), 
	"MEDIA_RELATED_TO_7" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_8" VARCHAR2(255), 
	"MEDIA_RELATED_TO_8" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_9" VARCHAR2(255), 
	"MEDIA_RELATED_TO_9" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_10" VARCHAR2(255), 
	"MEDIA_RELATED_TO_10" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_11" VARCHAR2(255), 
	"MEDIA_RELATED_TO_11" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_12" VARCHAR2(255), 
	"MEDIA_RELATED_TO_12" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_13" VARCHAR2(255), 
	"MEDIA_RELATED_TO_13" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_14" VARCHAR2(255), 
	"MEDIA_RELATED_TO_14" VARCHAR2(255), 
	"MEDIA_RELATIONSHIP_15" VARCHAR2(255), 
	"MEDIA_RELATED_TO_15" VARCHAR2(255)
   ) ;
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_TYPE" IS 'REQUIRED: See <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_TYPE">Use controlled vocabulary</a>.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."PREVIEW_URI" IS 'Path to thumbnail image.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."STATUS" IS 'Error messages will appear in this field.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LICENSE_ID" IS 'Possible values are 1, 4, 5, 6, 7, 8, 9. <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LICENSE">See controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MASK_MEDIA" IS 'Encumbers media. Values are 1 (encumber) or zero (do not encumber). If left blank, media will be public.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."USERNAME" IS 'Person who added these temporary rows.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."HEIGHT" IS 'Height of media in pixels - Does not change the intrinsic height. This will be calculated.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."WIDTH" IS 'Width of media in pixels - does not change the intrinsic width; this will be calculated.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MADE_DATE" IS 'REQUIRED: The date the media was made. It should be in the format YYYY-MM-DD. Most formats given in the spreadsheet are rearranged to the proper format automatically, but the dates should be checked at the validation step.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."SUBJECT" IS 'REQUIRED: What or who is shown in the image (i.e., text describing the general subject of the media). It is used as a keyword for users searching media and may duplicate media relationship such as "shows collector: Louis Agassiz."';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."DESCRIPTION" IS 'REQUIRED: Description of media (i.e., context of media). The description is part of the alt attribute in html, which is required for accessibility and shows when the there is a problem loading the image. Blind or low vision users of MCZbase using screen readers will be read the alt attributes to better understand an on-page image. Use the description to add information not already included in the other media labels and highlight the important aspects of the image. Keep it as concise as possible. Some of the media labels will be combined to autogenerate the alternative text for images when a description is not provided. On all permit- and transaction-related media, the description will be shown as a caption when viewing the permit or transaction.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LABEL_1" IS 'Label type 1 - <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LABEL">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."LABEL_VALUE_1" IS 'Label value 1 ';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LABEL_2" IS 'Label type 2 - <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LABEL">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."LABEL_VALUE_2" IS 'Label value 2';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LABEL_3" IS 'Label type 3 - <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LABEL">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."LABEL_VALUE_3" IS 'Label value 3';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LABEL_4" IS 'Label type 4 - <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LABEL">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."LABEL_VALUE_4" IS 'Label value 4';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LABEL_5" IS 'Label type 5 - <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LABEL">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."LABEL_VALUE_5" IS 'Label value 5';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LABEL_6" IS 'Label type 6 - <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LABEL">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."LABEL_VALUE_6" IS 'Label value 6';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LABEL_7" IS 'Label type 7 - <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LABEL">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."LABEL_VALUE_7" IS 'Label value 7';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_LABEL_8" IS 'Label type 8 - <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_LABEL">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."LABEL_VALUE_8" IS 'Label value 8';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_RELATIONSHIP_1" IS 'Relationship type 1 <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_RELATIONSHIP">See controlled vocabulary</a>.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_RELATED_TO_1" IS 'Relationship value 1  should be an ID, GUID, or NAME.  IDs such as agent_id, collecting_event_id, permit_id, or in the case of cataloged_item or specimen_part, it should be in the form of a guid (e.g., MCZ:Ent:1234). Agent,  Project, and Named Groups can use exact names (match to database).';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_RELATIONSHIP_2" IS 'Relationship type 2 <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_RELATIONSHIP">See controlled vocabulary</a>.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_RELATED_TO_2" IS 'Relationship value 2 should be an ID, GUID, or NAME.  IDs such as agent_id, collecting_event_id, permit_id, or in the case of cataloged_item or specimen_part, it should be in the form of a guid (e.g., MCZ:Ent:1234). Agent,  Project, and Named Groups can use exact names (match to database).';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_RELATIONSHIP_3" IS 'Relationship type 3 <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_RELATIONSHIP">See controlled vocabulary</a>.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_RELATED_TO_3" IS 'Relationship value 3  should be an ID, GUID, or NAME.  IDs such as agent_id, collecting_event_id, permit_id, or in the case of cataloged_item or specimen_part, it should be in the form of a guid (e.g., MCZ:Ent:1234). Agent,  Project, and Named Groups can use exact names (match to database).';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_RELATIONSHIP_4" IS 'Relationship type 4 <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMEDIA_RELATIONSHIP">See controlled vocabulary</a>.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_RELATED_TO_4" IS 'Relationship value 4  should be an ID, GUID, or NAME.  IDs such as agent_id, collecting_event_id, permit_id, or in the case of cataloged_item or specimen_part, it should be in the form of a guid (e.g., MCZ:Ent:1234). Agent,  Project, and Named Groups can use exact names (match to database).';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MD5HASH" IS 'MD5 message-digest algorithm. Verifies data integrity against unintentional corruption.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."CREATED_BY_AGENT_ID" IS 'Person who created the relationship rows. ';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MEDIA_URI" IS 'REQUIRED: Shared drive path or external http address.';
COMMENT ON COLUMN "CF_TEMP_MEDIA"."MIME_TYPE" IS 'REQUIRED: MIME = Multipurpose Internet Mail Extensions indicates the nature and format of a doc, file or assortment of bytes (e.g., audio/mpeg, image/png). <a href="/vocabularies/ControlledVocabulary.cfm?table=CTMIME_TYPE">See controlled vocabulary</a>.';
