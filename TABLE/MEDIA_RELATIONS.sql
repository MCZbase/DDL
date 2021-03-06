
  CREATE TABLE "MEDIA_RELATIONS" 
   (	"MEDIA_RELATIONS_ID" NUMBER NOT NULL ENABLE, 
	"MEDIA_ID" NUMBER NOT NULL ENABLE, 
	"MEDIA_RELATIONSHIP" VARCHAR2(40 CHAR) NOT NULL ENABLE, 
	"CREATED_BY_AGENT_ID" NUMBER NOT NULL ENABLE, 
	"RELATED_PRIMARY_KEY" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "PK_MEDIA_RELATIONS" PRIMARY KEY ("MEDIA_RELATIONS_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_MEDIARELNS_MEDIA" FOREIGN KEY ("MEDIA_ID")
	  REFERENCES "MEDIA" ("MEDIA_ID") ENABLE, 
	 CONSTRAINT "FK_MEDIARELNS_CTMEDIARELNS" FOREIGN KEY ("MEDIA_RELATIONSHIP")
	  REFERENCES "CTMEDIA_RELATIONSHIP" ("MEDIA_RELATIONSHIP") ENABLE, 
	 CONSTRAINT "FK_MEDIARELNS_AGENT" FOREIGN KEY ("CREATED_BY_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) 