
  CREATE TABLE "CF_TEMP_GEOREF" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"STATUS" VARCHAR2(4000 CHAR), 
	"DETERMINED_BY_AGENT_ID" NUMBER, 
	"HIGHERGEOGRAPHY" VARCHAR2(255 CHAR), 
	"SPECLOCALITY" VARCHAR2(255 CHAR), 
	"LOCALITY_ID" NUMBER, 
	"DEC_LAT" VARCHAR2(20) NOT NULL ENABLE, 
	"DEC_LONG" VARCHAR2(20) NOT NULL ENABLE, 
	"MAX_ERROR_DISTANCE" VARCHAR2(20) NOT NULL ENABLE, 
	"MAX_ERROR_UNITS" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"LAT_LONG_REMARKS" VARCHAR2(4000 CHAR), 
	"DETERMINED_BY_AGENT" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"GEOREFMETHOD" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"ORIG_LAT_LONG_UNITS" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"DATUM" VARCHAR2(55 CHAR) NOT NULL ENABLE, 
	"DETERMINED_DATE" VARCHAR2(20) NOT NULL ENABLE, 
	"LAT_LONG_REF_SOURCE" VARCHAR2(500 CHAR) NOT NULL ENABLE, 
	"EXTENT" VARCHAR2(20), 
	"GPSACCURACY" VARCHAR2(20), 
	"VERIFICATIONSTATUS" VARCHAR2(40 CHAR) NOT NULL ENABLE, 
	"SPATIALFIT" VARCHAR2(20), 
	"NEAREST_NAMED_PLACE" VARCHAR2(255), 
	"USERNAME" VARCHAR2(1020), 
	"VERIFIED_BY" VARCHAR2(255), 
	"VERIFIED_BY_AGENT_ID" VARCHAR2(255), 
	"ACCEPTED_LAT_LONG_FG" VARCHAR2(20), 
	"COORDINATE_PRECISION" VARCHAR2(20) NOT NULL ENABLE, 
	"EXTENT_UNITS" VARCHAR2(20), 
	"LAT_LONG_FOR_NNP_FG" VARCHAR2(20), 
	"UTM_ZONE" VARCHAR2(50), 
	"UTM_EW" VARCHAR2(50), 
	"UTM_NS" VARCHAR2(50), 
	"LAT_DEG" VARCHAR2(20), 
	"LAT_MIN" VARCHAR2(20), 
	"LAT_SEC" VARCHAR2(20), 
	"LAT_DIR" VARCHAR2(20), 
	"LONG_DEG" VARCHAR2(20), 
	"LONG_MIN" VARCHAR2(20), 
	"LONG_SEC" VARCHAR2(20), 
	"LONG_DIR" VARCHAR2(20)
   ) ;
COMMENT ON COLUMN "CF_TEMP_GEOREF"."KEY" IS 'Surrogate numeric primary key.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."STATUS" IS 'Error messages regarding loading will appear here.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."DETERMINED_BY_AGENT_ID" IS 'DETERMINED_BY_AGENT_ID is generated from the DETERMINED_BY_AGENT field in the validation step.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."HIGHERGEOGRAPHY" IS 'REQUIRED along with SPECLOCALITY if LOCALITY_ID is not provided. Highest level of geographic designations from broadest to most specific. Match higher geography in MCZbase. Search <a href="/localities/HigherGeographies.cfm">Higher Geography</a>.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."SPECLOCALITY" IS 'REQUIRED along with HIGHERGEOGRAPHY if LOCALITY_ID is not provided. Directions to the collection point inside the county boundaries. Must match specific locality existing in MCZbase. Search <a href="/localities/Localities.cfm">Localities</a>.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LOCALITY_ID" IS 'REQUIRED if HIGHERGEOGRAPHY and SPECLOCALITY are not provided. Number representing the locality record. Search <a href="/localities/Localities.cfm">Localities</a> for the locality ID.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."DEC_LAT" IS 'REQUIRED. All other latitude units should be converted to DEC_LAT. Use <a href="https://www.pgc.umn.edu/apps/convert/" target="_blank">Coordinate Converter</a>.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."DEC_LONG" IS 'REQUIRED. All other longitude units should be converted to DEC_LONG.  Use <a href="https://www.pgc.umn.edu/apps/convert/" target="_blank">Coordinate Converter</a>.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."MAX_ERROR_DISTANCE" IS 'REQUIRED.  The horizontal distance (in units specified in MAX_ERROR_UNITS) from the given Latitude and Longitude describing the smallest circle containing the whole of the dcterms:Location.  ';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."MAX_ERROR_UNITS" IS 'REQUIRED. The units in which the MAX_ERROR_DISTANCE are recorded. See <a href="/vocabularies/ControlledVocabulary.cfm?table=CTLAT_LONG_ERROR_UNITS">Controlled Vocabulary</a>.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LAT_LONG_REMARKS" IS 'Remarks associated with the LAT and LONG determination. The limit is 4000 characters.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."DETERMINED_BY_AGENT" IS 'REQUIRED. Agent who determined LAT and LONG associated data. Must exactly match an existing AGENT NAME (preferred) in MCZbase. See <a href="/Agents.cfm">Agent Search</a>';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."GEOREFMETHOD" IS 'REQUIRED. Description of the formal Georeferencing Protocol used in determining the coordinates. See <a href="/vocabularies/ControlledVocabulary.cfm?table=CTGEOREFMETHOD">Controlled Vocabulary</a>.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."ORIG_LAT_LONG_UNITS" IS 'REQUIRED. Original standard format in which locality coordinates were entered.  Currently, only decimal degrees and deg. min. sec. are supported.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."DATUM" IS 'REQUIRED. Horizontal geodetic datum (expressing the shape of the Earth) for the coordinates (e.g., WGS84, NAD27), or spatial reference system for the decimal degrees.  EPSG code for CRS is preferred.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."DETERMINED_DATE" IS 'REQUIRED. Date the georeference was made. If unknown, use approximate date. Use format YYYY-MM-DD.  Check to see that dates were converted correctly if not in the YYYY-MM-DD order. An error message will occur if it the date is missing.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LAT_LONG_REF_SOURCE" IS 'REQUIRED. The source of the georeference, including after-the-fact georeferencing efforts as well as original data. See <a href="/vocabularies/ControlledVocabulary.cfm?table=CTLAT_LONG_REF_SOURCE">Controlled Vocabulary</a>.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."EXTENT" IS 'Radial of Feature.  Length of  the line segment from the corcenter of the location to the furthest point on the boundary of the geographic extent of that location.   The distance from a point defined by lat/long coordinates to the outer perimeter of the feature of origin (e.g., from the center of town to the farthest point on the boundary).   Number only.   Specify units for the number in EXTENT_UNITS.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."GPSACCURACY" IS 'Error reported by a Global Positioning System receiver or other GNSS receiver in meters. If unknown, a current default of 30 meters is the standard. Enter number only, Units are in meters.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."VERIFICATIONSTATUS" IS 'REQUIRED. Description of the extent to which the georeference has been verified by the collector agent to accurately reflect the collection site of the specimen. See <a href="/vocabularies/ControlledVocabulary.cfm?table=CTVERIFICATIONSTATUS">controlled vocabulary</a>';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."SPATIALFIT" IS 'The ratio of the area of the point-radius uncertainty to the area of the true spatial representation of the location. Legal values are 0, 1, or blank. A value of 1 is an exact match. A value of 0 should be used if the given point-radius does not completely contain the original representation.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."NEAREST_NAMED_PLACE" IS 'Nearest place to a set of coordinates or the place name used to determine the coordinates.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."USERNAME" IS 'Person who added these temporary rows for uploading into MCZbase. Login name.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."VERIFIED_BY" IS 'Person who verified the coordinates. Must match agent record preferred name in MCZbase. <a href="https://mczbase.mcz.harvard.edu/Agents.cfm">Agent Search.</a>';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."VERIFIED_BY_AGENT_ID" IS 'VERIFIED_BY_AGENT_ID is the agent_id of verifier. Automatically generated from VERIFIED_BY name in the next step.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."ACCEPTED_LAT_LONG_FG" IS 'All rows will be accepted georeferences.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."COORDINATE_PRECISION" IS 'REQUIRED. Integer 0 to 6, indicating the number of significant digits in the decimal latitude and decimal longitude. Zero is precision to one degree, 1 is precision to one tenth of a degree. A  lat/long rounded up to a single decimal place can accurately identify a country or region, whereas rounded up to two could identify a large city or district. Five decimal places can accurately hone in on an individual tree, and six can identify a person.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."EXTENT_UNITS" IS 'Units for the EXTENT (Radial of feature).';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LAT_LONG_FOR_NNP_FG" IS 'Optional.  Georeference is of the nearest named place. Enter 1 for Yes or 0 for No.    If 1, NEAREST_NAMED_PLACE must also be provided.  Not normally used if additional locality information is available to place a locality at some offset from a named place.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."UTM_ZONE" IS 'If original units are UTM coordinates, the UTM Zone, possibly including the band letter.  Does not support USNG or MGRS coordinates with 100000m grid square letters.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."UTM_EW" IS 'If original units are UTM coordinates, the UTM Easting as a number only.  Does not support USNG or MGRS coordinates with 100000m grid square letters.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."UTM_NS" IS 'If original units are UTM coordinates, the UTM Northing as a number only.  Does not support USNG or MGRS coordinates with 100000m grid square letters.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LAT_DEG" IS 'The degree portion of the latitude, as a positive integer in the range 0 to 90';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LAT_MIN" IS 'If original units are Degrees, Minutes, Seconds, the minutes of latitude, as an integer in the range 0 to 60.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LAT_SEC" IS 'If original units are Degrees, Minutes, Seconds, the seconds of latitude, as a number in the range 0 to 60.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LAT_DIR" IS 'The direction of the latitude from the Equator, N or S.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LONG_DEG" IS 'The degree portion of the longitude, as a postive integer in the range 0 to 180.';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LONG_MIN" IS 'If original units are Degrees, Minutes, Seconds, the minutes of longitude, as an integerin the range 0 to 60';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LONG_SEC" IS 'If original units are Degrees, Minutes, Seconds, the seconds of longitude, as a number in the range 0 to 60';
COMMENT ON COLUMN "CF_TEMP_GEOREF"."LONG_DIR" IS 'The direction of the longitude from the meridian, E or W.';
