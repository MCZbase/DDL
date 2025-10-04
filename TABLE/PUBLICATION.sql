
  CREATE TABLE "PUBLICATION" 
   (	"PUBLICATION_ID" NUMBER NOT NULL ENABLE, 
	"PUBLISHED_YEAR" NUMBER, 
	"PUBLICATION_TYPE" VARCHAR2(21 CHAR) NOT NULL ENABLE, 
	"PUBLICATION_LOC" VARCHAR2(255 CHAR), 
	"PUBLICATION_TITLE" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	"PUBLICATION_REMARKS" VARCHAR2(1000 CHAR), 
	"IS_PEER_REVIEWED_FG" NUMBER(22,0) NOT NULL ENABLE, 
	"DOI" VARCHAR2(4000), 
	"LAST_UPDATE_DATE" TIMESTAMP (6), 
	 CONSTRAINT "CK_PEER_FLAG" CHECK (is_peer_reviewed_fg IN (0,1)) ENABLE, 
	 CONSTRAINT "FK_CTPUBLICATION_TYPE" FOREIGN KEY ("PUBLICATION_TYPE")
	  REFERENCES "CTPUBLICATION_TYPE" ("PUBLICATION_TYPE") ENABLE
   ) 
  CREATE UNIQUE INDEX "PKEY_PUBLICATION" ON "PUBLICATION" ("PUBLICATION_ID") 
  
ALTER TABLE "PUBLICATION" ADD CONSTRAINT "PK_PUBLICATION" PRIMARY KEY ("PUBLICATION_ID")
  USING INDEX "PKEY_PUBLICATION"  ENABLE;
COMMENT ON COLUMN "PUBLICATION"."PUBLICATION_ID" IS 'surrogate numeric primary key';
COMMENT ON COLUMN "PUBLICATION"."PUBLISHED_YEAR" IS 'year of publication, if range, the first year of range.  Domain: integers representing years';
COMMENT ON COLUMN "PUBLICATION"."PUBLICATION_TYPE" IS 'category of publication, determines which attributes are expected to apply and how they are assembled into the full citation.';
COMMENT ON COLUMN "PUBLICATION"."PUBLICATION_LOC" IS 'storage location at which a physical copy of the publication can be found.   Not intended for electronic resources.  Use DOI for a DOI for a publication.  Add a media object to relate a publication to an electronic resource.';
COMMENT ON COLUMN "PUBLICATION"."PUBLICATION_TITLE" IS 'the title of the publication in its original language, optionally with a translation in square brackets.';
COMMENT ON COLUMN "PUBLICATION"."PUBLICATION_REMARKS" IS 'free text remarks concerning the publication';
COMMENT ON COLUMN "PUBLICATION"."IS_PEER_REVIEWED_FG" IS 'flag indicating whether or not the pulication is peer reviewed';
COMMENT ON COLUMN "PUBLICATION"."DOI" IS 'digital object identifier for the publication';
COMMENT ON COLUMN "PUBLICATION"."LAST_UPDATE_DATE" IS 'timestamp of the most recent update to the publication record.';
