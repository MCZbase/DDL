
  CREATE TABLE "LOCALITY" 
   (	"LOCALITY_ID" NUMBER NOT NULL ENABLE, 
	"GEOG_AUTH_REC_ID" NUMBER NOT NULL ENABLE, 
	"MAXIMUM_ELEVATION" NUMBER, 
	"MINIMUM_ELEVATION" NUMBER, 
	"ORIG_ELEV_UNITS" VARCHAR2(2 CHAR), 
	"TOWNSHIP" NUMBER, 
	"TOWNSHIP_DIRECTION" CHAR(1 CHAR), 
	"RANGE" NUMBER, 
	"RANGE_DIRECTION" CHAR(1 CHAR), 
	"SECTION" NUMBER, 
	"SECTION_PART" VARCHAR2(30 CHAR), 
	"SPEC_LOCALITY" VARCHAR2(400 CHAR), 
	"LOCALITY_REMARKS" VARCHAR2(4000 CHAR), 
	"LEGACY_SPEC_LOCALITY_FG" NUMBER, 
	"DEPTH_UNITS" VARCHAR2(20 CHAR), 
	"MIN_DEPTH" NUMBER, 
	"MAX_DEPTH" NUMBER, 
	"NOGEOREFBECAUSE" VARCHAR2(500), 
	"GEOREF_UPDATED_DATE" DATE, 
	"GEOREF_BY" VARCHAR2(50 CHAR), 
	"SOVEREIGN_NATION" VARCHAR2(255) DEFAULT '[unknown]', 
	 CONSTRAINT "PK_LOCALITY" PRIMARY KEY ("LOCALITY_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "MIN_MORE_MAX_ELEV" CHECK (MINIMUM_ELEVATION <= MAXIMUM_ELEVATION) ENABLE, 
	 CONSTRAINT "FK_CTORIG_ELEV_UNITS" FOREIGN KEY ("ORIG_ELEV_UNITS")
	  REFERENCES "CTORIG_ELEV_UNITS" ("ORIG_ELEV_UNITS") ENABLE, 
	 CONSTRAINT "FK_LOCALITY_GEOGAUTHREC" FOREIGN KEY ("GEOG_AUTH_REC_ID")
	  REFERENCES "GEOG_AUTH_REC" ("GEOG_AUTH_REC_ID") ENABLE
   ) 