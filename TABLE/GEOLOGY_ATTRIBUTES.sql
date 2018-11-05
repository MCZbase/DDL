
  CREATE TABLE "GEOLOGY_ATTRIBUTES" 
   (	"GEOLOGY_ATTRIBUTE_ID" NUMBER NOT NULL ENABLE, 
	"LOCALITY_ID" NUMBER NOT NULL ENABLE, 
	"GEOLOGY_ATTRIBUTE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"GEO_ATT_VALUE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"GEO_ATT_DETERMINER_ID" NUMBER, 
	"GEO_ATT_DETERMINED_DATE" DATE, 
	"GEO_ATT_DETERMINED_METHOD" VARCHAR2(255 CHAR), 
	"GEO_ATT_REMARK" VARCHAR2(4000 CHAR), 
	 CONSTRAINT "PK_GEOLOGY_ATTRIBUTES" PRIMARY KEY ("GEOLOGY_ATTRIBUTE_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_GEOLATTRIBUTES_LOCALITY" FOREIGN KEY ("LOCALITY_ID")
	  REFERENCES "LOCALITY" ("LOCALITY_ID") ENABLE
   ) 