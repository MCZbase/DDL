
  CREATE TABLE "TAG" 
   (	"TAG_ID" NUMBER NOT NULL ENABLE, 
	"MEDIA_ID" NUMBER NOT NULL ENABLE, 
	"REMARK" VARCHAR2(4000 CHAR), 
	"REFTOP" NUMBER, 
	"REFLEFT" NUMBER, 
	"REFH" NUMBER, 
	"REFW" NUMBER, 
	"IMGH" NUMBER, 
	"IMGW" NUMBER, 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"COLLECTING_EVENT_ID" NUMBER, 
	"LOCALITY_ID" NUMBER, 
	"AGENT_ID" NUMBER, 
	 CONSTRAINT "TAG_PK" PRIMARY KEY ("TAG_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_TAG_COLLEVENT" FOREIGN KEY ("COLLECTING_EVENT_ID")
	  REFERENCES "COLLECTING_EVENT" ("COLLECTING_EVENT_ID") ENABLE
   ) ;
COMMENT ON TABLE "TAG" IS 'A region of interest in an image.';
COMMENT ON COLUMN "TAG"."TAG_ID" IS 'Surrogate numeric primary key';
COMMENT ON COLUMN "TAG"."MEDIA_ID" IS 'Media record for the image to which this region of interest applies.';
COMMENT ON COLUMN "TAG"."REMARK" IS 'Free text assertions about the region of interest.';
COMMENT ON COLUMN "TAG"."REFTOP" IS 'Y offset of top of region of interest from top of image.';
COMMENT ON COLUMN "TAG"."REFLEFT" IS 'X offset of left side of region of interest from left of image.';
COMMENT ON COLUMN "TAG"."REFH" IS 'Y height of region of interest below REFTop';
COMMENT ON COLUMN "TAG"."REFW" IS 'Y width of region of interest right of REFLeft';
COMMENT ON COLUMN "TAG"."IMGH" IS 'Height of image';
COMMENT ON COLUMN "TAG"."IMGW" IS 'Width of image';
COMMENT ON COLUMN "TAG"."COLLECTION_OBJECT_ID" IS 'Collection object shown in the region of interest.';
COMMENT ON COLUMN "TAG"."COLLECTING_EVENT_ID" IS 'Collecting event shown in the region of interest.';
COMMENT ON COLUMN "TAG"."LOCALITY_ID" IS 'Locality shown in the region of interest.';
COMMENT ON COLUMN "TAG"."AGENT_ID" IS 'Agent shown in the region of interest.';
