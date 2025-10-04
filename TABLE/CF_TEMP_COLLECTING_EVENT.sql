
  CREATE TABLE "CF_TEMP_COLLECTING_EVENT" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"LOCALITY_ID" VARCHAR2(20), 
	"VERBATIM_DATE" VARCHAR2(60 CHAR), 
	"VERBATIM_LOCALITY" VARCHAR2(2000 CHAR), 
	"COLL_EVENT_REMARKS" VARCHAR2(4000 CHAR), 
	"VALID_DISTRIBUTION_FG" VARCHAR2(50 CHAR), 
	"COLLECTING_SOURCE" VARCHAR2(30 CHAR), 
	"COLLECTING_METHOD" VARCHAR2(255), 
	"HABITAT_DESC" VARCHAR2(500 CHAR), 
	"DATE_DETERMINED_BY_AGENT" VARCHAR2(255), 
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
	"STARTDAYOFYEAR" VARCHAR2(50 CHAR), 
	"ENDDAYOFYEAR" VARCHAR2(50 CHAR), 
	"VERBATIMELEVATION" VARCHAR2(500), 
	"VERBATIMDEPTH" VARCHAR2(500), 
	"VERBATIM_COLLECTORS" VARCHAR2(2000), 
	"VERBATIM_FIELD_NUMBERS" VARCHAR2(500), 
	"VERBATIM_HABITAT" VARCHAR2(2000), 
	"USERNAME" VARCHAR2(1020) NOT NULL ENABLE, 
	"STATUS" VARCHAR2(4000), 
	"SPEC_LOCALITY" VARCHAR2(400 CHAR)
   )   NO INMEMORY 
  CREATE UNIQUE INDEX "CF_TEMP_COLL_EVENT_PK" ON "CF_TEMP_COLLECTING_EVENT" ("KEY") 
  
ALTER TABLE "CF_TEMP_COLLECTING_EVENT" ADD CONSTRAINT "PK_CF_TEMP_COLLECTING_EVENT" PRIMARY KEY ("KEY")
  USING INDEX "CF_TEMP_COLL_EVENT_PK"  ENABLE;
COMMENT ON TABLE "CF_TEMP_COLLECTING_EVENT" IS 'Temporary table for bulkloading collecting events.  Supports collecting event bulkloader.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."KEY" IS 'Surrogate numeric primary key.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."LOCALITY_ID" IS 'Required.  Number.  The locality_id for the locality to which this collecting event is to be attached.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIM_DATE" IS 'Required. Verbatim text representing the date on which the collecting event occurred.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIM_LOCALITY" IS 'Verbatim text describing the locality at which the collecting event occurred.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."COLL_EVENT_REMARKS" IS 'Free text remarks concerning this collecting event.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VALID_DISTRIBUTION_FG" IS 'Does this collecting event represent the collection of an organism in the wild.  The value 1 represents the normal case, including collecting of fossils.  The value 0 represents cases such as zoo or lab specimens where the collecting event is not from the wild.  ';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."COLLECTING_SOURCE" IS 'Required.  General sort of provenance for material recorded in this collecting event.  Controlled vocabulary <a href="/vocabularies/ControlledVocabulary.cfm?table=CTCOLLECTING_SOURCE" target="_blank">CTCOLLECTING_SOURCE</a>.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."COLLECTING_METHOD" IS 'Means by which material collected in this collecting event were collected or recorded.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."HABITAT_DESC" IS 'Information about the habitat present at the locality at the time of the collecting event.   Departments may standardize from verbatim_habitat.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."DATE_DETERMINED_BY_AGENT" IS 'Name of the agent who determined the values of began_date and ended_date, must match a unique agent name.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."DATE_DETERMINED_BY_AGENT_ID" IS 'Optional. Agent id of the agent who determined the values of began_date and ended_date, use to disambiguate cases where more than one agent shares the same name.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."FISH_FIELD_NUMBER" IS 'Ichthyology use only.  Field number assigned to the collecting event by the Ichthyology department.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."BEGAN_DATE" IS 'Required.  The ISO date (yyyy, yyyy-mm, or yyyy-mm-dd) on which the collecting event began.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."ENDED_DATE" IS 'Required.  The ISO date (yyyy, yyyy-mm, or yyyy-mm-dd) on which the collecting event ended.  If event was within one day, use the same value as began_date.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."COLLECTING_TIME" IS 'Time of day during which the collecting event occurred.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIMCOORDINATES" IS 'The original verbatim coordinate in whatever form, UTM, MGRS, USNG, PLSS, Lat/Long, etc ';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIMLATITUDE" IS 'The verbatim longitude portion of the verbatim coordinates, if they are geographic (lat/long) coordinates,  non lat/long coordinates should not go here';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIMLONGITUDE" IS 'The verbatim latitude portion of the verbatim coordinates, if they are geographic (lat/long) coordinates, non lat/long coordinates should not go here';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIMCOORDINATESYSTEM" IS 'The coordinate system in which the verbatim coordinates are expressed, in human readable form, e.g. decimal degrees, degrees minutes seconds, UTM, MGRS, USNG, PLSS, etc.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIMSRS" IS 'The spatial reference system for the verbatim coordinates.  Use an EPSG code, e.g. "EPSG: 4326" (which is the code for geographic coordinates expressed in decimal degrees using the WGS84 datum).  This is not a Verbatim value, but the spatial reference system for the verbatim coordinates.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."STARTDAYOFYEAR" IS 'Optional.  The day of the year on which the collecting event began.  Useful for cases where day is known but year is not.  ';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."ENDDAYOFYEAR" IS 'Optional.  The day of the year on which the collecting event ended. Useful for cases where day is known but year is not.  ';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIMELEVATION" IS 'Verbatim information about the elevation at which this collecting event occurred.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIMDEPTH" IS 'Verbatim information about the depth at which this collecting event occurred.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIM_COLLECTORS" IS 'The verbatim list of collectors associated with this collecting event.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIM_FIELD_NUMBERS" IS 'Verbatim text that appears to be a field number, collecting event number, or other identifier that may be for this collecting event.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."VERBATIM_HABITAT" IS 'Verbatim text describing the habitat information associated with the collecting event.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."USERNAME" IS 'The user who created this temporary bulkload record.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."STATUS" IS 'Populated if a validation problem is found in the validation step.';
COMMENT ON COLUMN "CF_TEMP_COLLECTING_EVENT"."SPEC_LOCALITY" IS 'Required.  The specific locality for the locality, serves as a check for the locality_id, value must match locality.spec_locality exactly, does not alter the locality.';
