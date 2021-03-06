
  CREATE TABLE "GIS_US_COUNTIES" 
   (	"STATEFP" VARCHAR2(2), 
	"COUNTYFP" VARCHAR2(3), 
	"COUNTYNS" VARCHAR2(8), 
	"GEOID" VARCHAR2(5), 
	"NAME" VARCHAR2(100), 
	"NAMELSAD" VARCHAR2(100), 
	"LSAD" VARCHAR2(2), 
	"CLASSFP" VARCHAR2(2), 
	"MTFCC" VARCHAR2(5), 
	"CSAFP" VARCHAR2(3), 
	"CBSAFP" VARCHAR2(5), 
	"METDIVFP" VARCHAR2(5), 
	"FUNCSTAT" VARCHAR2(1), 
	"ALAND" NUMBER(38,0), 
	"AWATER" NUMBER(38,0), 
	"INTPTLAT" VARCHAR2(11), 
	"INTPTLON" VARCHAR2(12), 
	"SHAPE" "MDSYS"."SDO_GEOMETRY" 
   ) 