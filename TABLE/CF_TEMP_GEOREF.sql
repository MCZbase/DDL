
  CREATE TABLE "CF_TEMP_GEOREF" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"STATUS" VARCHAR2(4000 CHAR), 
	"DETERMINED_BY_AGENT_ID" NUMBER, 
	"HIGHERGEOGRAPHY" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"SPECLOCALITY" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"LOCALITY_ID" NUMBER NOT NULL ENABLE, 
	"DEC_LAT" NUMBER(12,10), 
	"DEC_LONG" NUMBER(13,10), 
	"MAX_ERROR_DISTANCE" NUMBER(12,5), 
	"MAX_ERROR_UNITS" VARCHAR2(20 CHAR), 
	"LAT_LONG_REMARKS" VARCHAR2(1000 CHAR), 
	"DETERMINED_BY_AGENT" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"GEOREFMETHOD" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"ORIG_LAT_LONG_UNITS" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"DATUM" VARCHAR2(55 CHAR) NOT NULL ENABLE, 
	"DETERMINED_DATE" DATE NOT NULL ENABLE, 
	"LAT_LONG_REF_SOURCE" VARCHAR2(1000 CHAR) NOT NULL ENABLE, 
	"EXTENT" NUMBER(12,5), 
	"GPSACCURACY" NUMBER(8,3), 
	"VERIFICATIONSTATUS" VARCHAR2(40 CHAR) NOT NULL ENABLE, 
	"SPATIALFIT" NUMBER(4,3), 
	"NEAREST_NAMED_PLACE" VARCHAR2(255)
   ) 