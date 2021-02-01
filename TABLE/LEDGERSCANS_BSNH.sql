
  CREATE TABLE "LEDGERSCANS_BSNH" 
   (	"DEPARTMENT" VARCHAR2(255), 
	"COLLECTION" VARCHAR2(255), 
	"VOLUMENAME" VARCHAR2(255), 
	"VOLUMETYPE" VARCHAR2(255), 
	"VOLUMEPAGE" NUMBER(22,0), 
	"STARTNUM" NUMBER(22,0), 
	"ENDNUM" NUMBER(22,0), 
	"CATNUMS" VARCHAR2(4000), 
	"FILENAME" VARCHAR2(255), 
	"SCANDATE" DATE, 
	"DEPOSITDATE" DATE, 
	"PDSOBJECTID" NUMBER(22,0), 
	"PDSURN" VARCHAR2(255), 
	"IDSOBJECTID" NUMBER(22,0), 
	"IDSURN" VARCHAR2(255), 
	"MOVED" VARCHAR2(5), 
	"ERROR" VARCHAR2(255), 
	"COLLECTION_CDE" VARCHAR2(10), 
	"CAT_NUM_PREFIX" VARCHAR2(10), 
	"MISSING_LINKS" NUMBER, 
	"ID" NUMBER, 
	"IDNUMBER_TYPE" VARCHAR2(50)
   ) 