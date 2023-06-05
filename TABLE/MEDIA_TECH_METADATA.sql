
  CREATE TABLE "MEDIA_TECH_METADATA" 
   (	"MEDIA_TECH_METADATA_ID" NUMBER, 
	"MEDIA_ID" NUMBER, 
	"METADATA_TYPE" VARCHAR2(100), 
	"METADATA_VALUE" VARCHAR2(100), 
	 CONSTRAINT "PK_MEDIA_TECH_METADATA_ID" PRIMARY KEY ("MEDIA_TECH_METADATA_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_MEDIA_TECH_MD_MEDIA" FOREIGN KEY ("MEDIA_ID")
	  REFERENCES "MEDIA" ("MEDIA_ID") ENABLE
   ) 