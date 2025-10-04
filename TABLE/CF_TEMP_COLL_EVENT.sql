
  CREATE TABLE "CF_TEMP_COLL_EVENT" 
   (	"COLLECTING_EVENT_ID" NUMBER, 
	"LOCALITY_ID" NUMBER NOT NULL ENABLE, 
	"DATE_BEGAN_DATE" DATE, 
	"DATE_ENDED_DATE" DATE, 
	"VERBATIM_DATE" VARCHAR2(60 CHAR) NOT NULL ENABLE, 
	"VERBATIM_LOCALITY" VARCHAR2(2000 CHAR), 
	"COLL_EVENT_REMARKS" VARCHAR2(500 CHAR), 
	"VALID_DISTRIBUTION_FG" VARCHAR2(20), 
	"COLLECTING_SOURCE" VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	"COLLECTING_METHOD" VARCHAR2(255), 
	"HABITAT_DESC" VARCHAR2(500 CHAR), 
	"DATE_DETERMINED_BY_AGENT_ID" NUMBER, 
	"FISH_FIELD_NUMBER" VARCHAR2(50 CHAR), 
	"BEGAN_DATE" VARCHAR2(22 CHAR), 
	"ENDED_DATE" VARCHAR2(22 CHAR), 
	"COLLECTING_TIME" VARCHAR2(50), 
	"VERBATIMCOORDINATES" VARCHAR2(100 CHAR), 
	"VERBATIMLATITUDE" VARCHAR2(50 CHAR), 
	"VERBATIMLONGITUDE" VARCHAR2(50 CHAR), 
	"VERBATIMCOORDINATESYSTEM" VARCHAR2(50 CHAR), 
	"VERBATIMSRS" VARCHAR2(50 CHAR), 
	"STARTDAYOFYEAR" NUMBER(3,0), 
	"ENDDAYOFYEAR" NUMBER(3,0), 
	"VERBATIMELEVATION" VARCHAR2(500), 
	"VERBATIMDEPTH" VARCHAR2(500), 
	"KEY" NUMBER NOT NULL ENABLE
   ) ;
COMMENT ON TABLE "CF_TEMP_COLL_EVENT" IS '?? Unused copy of collecting_event table ??  Event at which material was collected or observed at some locality.  Similar concept to Gathering in ABCD.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."COLLECTING_EVENT_ID" IS 'Surrogate numeric primary key.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."LOCALITY_ID" IS 'Foreign key for the locality at which the collecting event occurred.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."DATE_BEGAN_DATE" IS 'deprecated field, legacy values retained.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."DATE_ENDED_DATE" IS 'deprecated field, legacy values retained.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."VERBATIM_DATE" IS 'Verbatim text information about the collecting event date.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."COLL_EVENT_REMARKS" IS 'Free text assertions concerning the collecting event.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."COLLECTING_SOURCE" IS 'General sort of provenance for material recorded in this collecting event.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."COLLECTING_METHOD" IS 'Means by which material collected in this collecting event were collected or recorded.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."HABITAT_DESC" IS 'Information about the habitat present at the locality at the time of the collecting event.  See also coll_object_remarks.habitat for microhabitat.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."FISH_FIELD_NUMBER" IS 'Field number assigned to the collecting event by the Ichtyology department.';
COMMENT ON COLUMN "CF_TEMP_COLL_EVENT"."COLLECTING_TIME" IS 'Time of day during which the collecting event occurred.';
