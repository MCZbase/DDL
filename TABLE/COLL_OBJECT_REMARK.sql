
  CREATE TABLE "COLL_OBJECT_REMARK" 
   (	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"DISPOSITION_REMARKS" VARCHAR2(4000 CHAR), 
	"COLL_OBJECT_REMARKS" VARCHAR2(4000 CHAR), 
	"HABITAT" VARCHAR2(4000 CHAR), 
	"ASSOCIATED_SPECIES" VARCHAR2(4000 CHAR), 
	 CONSTRAINT "FK_COLLOBJREM_COLLOBJECT" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "COLL_OBJECT" ("COLLECTION_OBJECT_ID") ENABLE
   ) ;
COMMENT ON COLUMN "COLL_OBJECT_REMARK"."COLLECTION_OBJECT_ID" IS 'The cataloged item to which the remarks apply';
COMMENT ON COLUMN "COLL_OBJECT_REMARK"."DISPOSITION_REMARKS" IS 'Comments or notes regarding the disposition of the collection object.';
COMMENT ON COLUMN "COLL_OBJECT_REMARK"."COLL_OBJECT_REMARKS" IS 'Comments or notes regarding the specimen.';
COMMENT ON COLUMN "COLL_OBJECT_REMARK"."HABITAT" IS 'Microhabitat information related to the gathering of the collection object.  See also collecting_event.habitat_desc for habitat information.';
COMMENT ON COLUMN "COLL_OBJECT_REMARK"."ASSOCIATED_SPECIES" IS 'Species found in association with the collection object in its gathering.';
