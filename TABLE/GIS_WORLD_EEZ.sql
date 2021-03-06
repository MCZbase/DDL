
  CREATE TABLE "GIS_WORLD_EEZ" 
   (	"MRGID" NUMBER(38,0), 
	"GEONAME" VARCHAR2(80), 
	"MRGID_TER1" NUMBER(38,0), 
	"POL_TYPE" VARCHAR2(80), 
	"MRGID_SOV1" NUMBER(38,0), 
	"TERRITORY1" VARCHAR2(80), 
	"ISO_TER1" VARCHAR2(80), 
	"SOVEREIGN1" VARCHAR2(80), 
	"MRGID_TER2" NUMBER(38,0), 
	"MRGID_SOV2" NUMBER(38,0), 
	"TERRITORY2" VARCHAR2(80), 
	"ISO_TER2" VARCHAR2(80), 
	"SOVEREIGN2" VARCHAR2(80), 
	"MRGID_TER3" NUMBER(38,0), 
	"MRGID_SOV3" NUMBER(38,0), 
	"TERRITORY3" VARCHAR2(80), 
	"ISO_TER3" VARCHAR2(80), 
	"SOVEREIGN3" VARCHAR2(80), 
	"X_1" NUMBER, 
	"Y_1" NUMBER, 
	"MRGID_EEZ" NUMBER(38,0), 
	"AREA_KM2" NUMBER(38,0), 
	"ISO_SOV1" VARCHAR2(80), 
	"ISO_SOV2" VARCHAR2(80), 
	"ISO_SOV3" VARCHAR2(80), 
	"UN_SOV1" NUMBER(38,0), 
	"UN_SOV2" NUMBER(38,0), 
	"UN_SOV3" NUMBER(38,0), 
	"UN_TER1" NUMBER(38,0), 
	"UN_TER2" NUMBER(38,0), 
	"UN_TER3" NUMBER(38,0), 
	"SHAPE" "MDSYS"."SDO_GEOMETRY" 
   ) 