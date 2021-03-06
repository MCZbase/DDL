
  CREATE TABLE "MEDIA_LABELS" 
   (	"MEDIA_LABEL_ID" NUMBER NOT NULL ENABLE, 
	"MEDIA_ID" NUMBER NOT NULL ENABLE, 
	"MEDIA_LABEL" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"LABEL_VALUE" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	"ASSIGNED_BY_AGENT_ID" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "PK_MEDIA_LABEL_ID" PRIMARY KEY ("MEDIA_LABEL_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_MEDIALABELS_MEDIA" FOREIGN KEY ("MEDIA_ID")
	  REFERENCES "MEDIA" ("MEDIA_ID") ENABLE, 
	 CONSTRAINT "FK_MEDIALABELS_AGENT" FOREIGN KEY ("ASSIGNED_BY_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   ) 