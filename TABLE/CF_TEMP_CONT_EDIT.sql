
  CREATE TABLE "CF_TEMP_CONT_EDIT" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"CONTAINER_UNIQUE_ID" VARCHAR2(60 CHAR), 
	"PARENT_UNIQUE_ID" VARCHAR2(60 CHAR), 
	"CONTAINER_TYPE" VARCHAR2(60 CHAR), 
	"CONTAINER_NAME" VARCHAR2(60 CHAR), 
	"DESCRIPTION" VARCHAR2(60 CHAR), 
	"REMARKS" VARCHAR2(60 CHAR), 
	"WIDTH" NUMBER, 
	"HEIGHT" NUMBER, 
	"LENGTH" NUMBER, 
	"NUMBER_POSITIONS" NUMBER, 
	"CONTAINER_ID" NUMBER, 
	"PARENT_CONTAINER_ID" NUMBER, 
	"STATUS" VARCHAR2(4000 CHAR), 
	"USERNAME" VARCHAR2(1020), 
	 CONSTRAINT "CF_TEMP_CONT_EDIT_PK" PRIMARY KEY ("KEY")
  USING INDEX  ENABLE
   ) ;
COMMENT ON TABLE "CF_TEMP_CONT_EDIT" IS 'Temporary table for holding loads of bulk changes to container parentage and metdata for validation and processing.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."KEY" IS 'Surrogate Numeric Primary Key';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."CONTAINER_UNIQUE_ID" IS 'Barcode or unique name of the container to move or change.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."PARENT_UNIQUE_ID" IS 'The barcode or container''s unique name into which the container is to be placed, that is directly above it in the nest of IDs for tracked objects.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."CONTAINER_TYPE" IS 'The type of container: Campus, Building, Floor, Room, Grouping, Fixture, Compartment, Tank, Envelope, Pin, Collection Object.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."CONTAINER_NAME" IS 'The name of the container. It could be anything if there is a barcode (e.g., snake drawer) and there could be more than one with the same name.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."DESCRIPTION" IS 'Description of the container (e.g., color, material, thickness). Example: black wooden box with foam liner 1/4 thick.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."REMARKS" IS 'Container remarks';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."WIDTH" IS 'Width of container';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."HEIGHT" IS 'Height of container';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."LENGTH" IS 'Length of container';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."NUMBER_POSITIONS" IS 'Number of positions (slots, levels, etc.).';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."CONTAINER_ID" IS 'Semiatuomatic, added key value from container_unique_id.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."PARENT_CONTAINER_ID" IS 'Semiautomatic, added key value from parent_unique_id.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."STATUS" IS 'Status from validation check, if non-null indicates a problem with the row.';
COMMENT ON COLUMN "CF_TEMP_CONT_EDIT"."USERNAME" IS 'The user who created these temporary rows.';
