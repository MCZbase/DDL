
  CREATE TABLE "LAT_LONG" 
   (	"LAT_LONG_ID" NUMBER NOT NULL ENABLE, 
	"LOCALITY_ID" NUMBER NOT NULL ENABLE, 
	"LAT_DEG" NUMBER, 
	"DEC_LAT_MIN" NUMBER(8,6), 
	"LAT_MIN" NUMBER, 
	"LAT_SEC" NUMBER(8,6), 
	"LAT_DIR" VARCHAR2(1 CHAR), 
	"LONG_DEG" NUMBER, 
	"DEC_LONG_MIN" NUMBER(10,8), 
	"LONG_MIN" NUMBER, 
	"LONG_SEC" NUMBER(8,6), 
	"LONG_DIR" VARCHAR2(1 CHAR), 
	"DEC_LAT" NUMBER(12,10), 
	"DEC_LONG" NUMBER(13,10), 
	"DATUM" VARCHAR2(55 CHAR) NOT NULL ENABLE, 
	"UTM_ZONE" VARCHAR2(3 CHAR), 
	"UTM_EW" NUMBER, 
	"UTM_NS" NUMBER, 
	"ORIG_LAT_LONG_UNITS" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"DETERMINED_BY_AGENT_ID" NUMBER NOT NULL ENABLE, 
	"DETERMINED_DATE" DATE NOT NULL ENABLE, 
	"LAT_LONG_REF_SOURCE" VARCHAR2(500 CHAR) NOT NULL ENABLE, 
	"LAT_LONG_REMARKS" VARCHAR2(4000 CHAR), 
	"MAX_ERROR_DISTANCE" NUMBER, 
	"MAX_ERROR_UNITS" VARCHAR2(2), 
	"NEAREST_NAMED_PLACE" VARCHAR2(255 CHAR), 
	"LAT_LONG_FOR_NNP_FG" NUMBER, 
	"FIELD_VERIFIED_FG" NUMBER, 
	"ACCEPTED_LAT_LONG_FG" NUMBER NOT NULL ENABLE, 
	"EXTENT" NUMBER(12,5), 
	"GPSACCURACY" NUMBER(8,3), 
	"GEOREFMETHOD" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"VERIFICATIONSTATUS" VARCHAR2(40 CHAR) NOT NULL ENABLE, 
	"SPATIALFIT" NUMBER(6,3), 
	"GEOLOCATE_UNCERTAINTYPOLYGON" VARCHAR2(4000), 
	"GEOLOCATE_SCORE" NUMBER(3,0), 
	"GEOLOCATE_PRECISION" VARCHAR2(25), 
	"GEOLOCATE_NUMRESULTS" NUMBER(3,0), 
	"GEOLOCATE_PARSEPATTERN" VARCHAR2(256), 
	"VERIFIED_BY_AGENT_ID" NUMBER, 
	"ERROR_POLYGON" CLOB, 
	"COORDINATE_PRECISION" NUMBER, 
	"FOOTPRINT_SPATIALFIT" NUMBER(6,3), 
	"EXTENT_UNITS" VARCHAR2(2), 
	 CONSTRAINT "ACCEPTED_LAT_LONG_FG_RANGE" CHECK (ACCEPTED_LAT_LONG_FG IN (0,1)) ENABLE, 
	 CONSTRAINT "DEC_LAT_RANGE" CHECK (dec_lat BETWEEN -90 AND 90) ENABLE, 
	 CONSTRAINT "DEC_LONG_RANGE" CHECK (dec_long BETWEEN -180 AND 180) ENABLE, 
	 CONSTRAINT "DEC_LAT_MIN_RANGE" CHECK (DEC_LAT_MIN >= 0 AND DEC_LAT_MIN < 60) ENABLE, 
	 CONSTRAINT "LONG_DEG_RANGE" CHECK (LONG_DEG BETWEEN 0 AND 180) ENABLE, 
	 CONSTRAINT "DEC_LONG_MIN_RANGE" CHECK (DEC_LONG_MIN >= 0 AND DEC_LONG_MIN < 60) ENABLE, 
	 CONSTRAINT "FK_CTLAT_LONG_ERROR_UNITS" FOREIGN KEY ("MAX_ERROR_UNITS")
	  REFERENCES "CTLAT_LONG_ERROR_UNITS" ("LAT_LONG_ERROR_UNITS") ENABLE, 
	 CONSTRAINT "FK_CTLAT_LONG_UNITS" FOREIGN KEY ("ORIG_LAT_LONG_UNITS")
	  REFERENCES "CTLAT_LONG_UNITS" ("ORIG_LAT_LONG_UNITS") ENABLE, 
	 CONSTRAINT "FK_LATLONG_LOCALITY" FOREIGN KEY ("LOCALITY_ID")
	  REFERENCES "LOCALITY" ("LOCALITY_ID") ENABLE, 
	 CONSTRAINT "FK_LATLONG_AGENT" FOREIGN KEY ("DETERMINED_BY_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_LATLONG_VERIFIEDBY" FOREIGN KEY ("VERIFIED_BY_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) 
  CREATE UNIQUE INDEX "PK_LAT_LONG_ID" ON "LAT_LONG" ("LAT_LONG_ID") 
  
ALTER TABLE "LAT_LONG" ADD CONSTRAINT "PK_LAT_LONG_ID" PRIMARY KEY ("LAT_LONG_ID")
  USING INDEX "PK_LAT_LONG_ID"  ENABLE;
COMMENT ON TABLE "LAT_LONG" IS 'A georeference.';
COMMENT ON COLUMN "LAT_LONG"."LAT_LONG_ID" IS 'Surrogate numeric primary key';
COMMENT ON COLUMN "LAT_LONG"."LOCALITY_ID" IS 'The locality for which this is a georeference.';
COMMENT ON COLUMN "LAT_LONG"."LAT_DEG" IS 'The degree portion of the latitude, expected to be a positive number in the range 0 to 90.';
COMMENT ON COLUMN "LAT_LONG"."DEC_LAT_MIN" IS 'For coordinates with an orig_lat_long_units of decimal minutes, the decimal minutes portion of the latitude.';
COMMENT ON COLUMN "LAT_LONG"."LAT_MIN" IS 'For coordinates with an orig_lat_long_units of degrees minutes seconds, the minutes portion of the latitude.';
COMMENT ON COLUMN "LAT_LONG"."LAT_SEC" IS 'For coordinates with an orig_lat_long_units of degrees minutes seconds, the seconds portion of the latitude.';
COMMENT ON COLUMN "LAT_LONG"."LAT_DIR" IS 'Direction for the latitude (lat_deg) N or S.   When N, dec_lat should be a positive number.';
COMMENT ON COLUMN "LAT_LONG"."LONG_DEG" IS 'The degree portion of the longitude, expected to be a positive number in the range 0 to 180.';
COMMENT ON COLUMN "LAT_LONG"."DEC_LONG_MIN" IS 'For coordinates with an orig_lat_long_units of decimal minutes, the decimal minutes portion of the longitude.';
COMMENT ON COLUMN "LAT_LONG"."LONG_MIN" IS 'For coordinates with an orig_lat_long_units of degrees minutes seconds, the minutes portion of the longitude.';
COMMENT ON COLUMN "LAT_LONG"."LONG_SEC" IS 'For coordinates with an orig_lat_long_units of degrees minutes seconds, the seconds portion of the longitude.';
COMMENT ON COLUMN "LAT_LONG"."LONG_DIR" IS 'Direction for the longitude (long_deg) E or W.   When E, dec_long should be a positive number.';
COMMENT ON COLUMN "LAT_LONG"."DEC_LAT" IS 'Semiautomatic, the latitude portion of the georeference represented as decimal degrees in the range -90 to 90. Expected to be populated for all georeferences, but this is not enforced.';
COMMENT ON COLUMN "LAT_LONG"."DEC_LONG" IS 'Semiautomatic, the longitude portion of the georeference represented as decimal degrees in the range -180 to 180.  Expected to be populated for all georeferences, but this is not enforced.';
COMMENT ON COLUMN "LAT_LONG"."DATUM" IS 'The horizontal geodedic datum or spatial reference system including geodetic datum for the georeference.';
COMMENT ON COLUMN "LAT_LONG"."UTM_ZONE" IS 'Universal Transverse Mercator zone designator,  May include latitude band letter.';
COMMENT ON COLUMN "LAT_LONG"."UTM_EW" IS 'UTM Easting';
COMMENT ON COLUMN "LAT_LONG"."UTM_NS" IS 'UTM Northing';
COMMENT ON COLUMN "LAT_LONG"."ORIG_LAT_LONG_UNITS" IS 'Form in which the latitude and longitude are stored in the georeference, degrees minutes seconds, degrees decimal minutes, or decimal degrees.  Determines which fields are combined to present the georeference in original form.';
COMMENT ON COLUMN "LAT_LONG"."DETERMINED_BY_AGENT_ID" IS 'Agent who made this georefernce.';
COMMENT ON COLUMN "LAT_LONG"."DETERMINED_DATE" IS 'Date on which this georeference was made.';
COMMENT ON COLUMN "LAT_LONG"."LAT_LONG_REF_SOURCE" IS 'Reference consulted as a source for the georeference.';
COMMENT ON COLUMN "LAT_LONG"."LAT_LONG_REMARKS" IS 'Free text comments regarding this georeference.';
COMMENT ON COLUMN "LAT_LONG"."MAX_ERROR_DISTANCE" IS 'Error radius for the georeference around the single specified coordinate.';
COMMENT ON COLUMN "LAT_LONG"."MAX_ERROR_UNITS" IS 'Units for max_error_distance.';
COMMENT ON COLUMN "LAT_LONG"."NEAREST_NAMED_PLACE" IS 'Nearest named place to the georefernce.';
COMMENT ON COLUMN "LAT_LONG"."LAT_LONG_FOR_NNP_FG" IS 'Flag indicating if the georeference is for the nearest named place.';
COMMENT ON COLUMN "LAT_LONG"."FIELD_VERIFIED_FG" IS 'Unused.  Deprecated.  Flag indicating verification status of this georeference.  ';
COMMENT ON COLUMN "LAT_LONG"."ACCEPTED_LAT_LONG_FG" IS 'Flag indicating if this is the accepted georeference for a locality.  1 is accepted, 2 is not accepted.';
COMMENT ON COLUMN "LAT_LONG"."EXTENT" IS 'The distance from a point defined by lat/long coordinates to the outer perimeter of the feature of origin';
COMMENT ON COLUMN "LAT_LONG"."GPSACCURACY" IS 'If georefernece was obtained from a GNSS/GPS reciever, the accuracy for the coordinate asserted by that recever at the time the location was recorded.';
COMMENT ON COLUMN "LAT_LONG"."GEOREFMETHOD" IS 'Method by which the georeference was made.';
COMMENT ON COLUMN "LAT_LONG"."VERIFICATIONSTATUS" IS 'Verification of the validity and accuracy of this georeference.';
COMMENT ON COLUMN "LAT_LONG"."SPATIALFIT" IS 'Ratio of the area of the point-radius uncertanty to actual area of the locality.  0 if locality is larger than point-radius, 1 if exact match, greater than 1 when point-radius is larger than locality by the ratio point-radius/locality';
COMMENT ON COLUMN "LAT_LONG"."GEOLOCATE_UNCERTAINTYPOLYGON" IS 'For georeferences returned from geolocate, either automated or manual, the uncertanty asserted by geolocate.';
COMMENT ON COLUMN "LAT_LONG"."GEOLOCATE_SCORE" IS 'For georeferences returned from geolocate, either automated or manual, the score for the selected georeference asserted by geolocate.';
COMMENT ON COLUMN "LAT_LONG"."GEOLOCATE_PRECISION" IS 'For georeferences returned from geolocate, either automated or manual, the precision asserted by geolocate.';
COMMENT ON COLUMN "LAT_LONG"."GEOLOCATE_NUMRESULTS" IS 'For georeferences returned from geolocate, either automated or manual, the number of results found by geolocate out of which the georeference was selected.';
COMMENT ON COLUMN "LAT_LONG"."GEOLOCATE_PARSEPATTERN" IS 'For georeferences returned from geolocate, either automated or manual, the pattern geolocate matched in the specific locality text that geolocate used to assert the georeference.';
COMMENT ON COLUMN "LAT_LONG"."VERIFIED_BY_AGENT_ID" IS 'Agent who verified the georeference.';
COMMENT ON COLUMN "LAT_LONG"."ERROR_POLYGON" IS 'Spatial shape, serialized as Well Known Text (WKT) that represents an error region within which the locality occurs.';
COMMENT ON COLUMN "LAT_LONG"."COORDINATE_PRECISION" IS 'Number of significant digits in the decimal lat/long';
COMMENT ON COLUMN "LAT_LONG"."FOOTPRINT_SPATIALFIT" IS 'Ratio of the the footprint (error polygon wkt) to the by the actual area of the of the locality.  0 if locality is larger than footprint, 1 if exact match, greater than 1 when footprint is larger than locality in ratio to footprint/locality.';
COMMENT ON COLUMN "LAT_LONG"."EXTENT_UNITS" IS 'units on the radial of feature (extent).';
