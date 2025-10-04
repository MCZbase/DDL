
  CREATE TABLE "UNDERSCORE_COLLECTION" 
   (	"UNDERSCORE_COLLECTION_ID" NUMBER NOT NULL ENABLE, 
	"COLLECTION_NAME" VARCHAR2(255) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(900), 
	"UNDERSCORE_AGENT_ID" NUMBER, 
	"MASK_FG" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	"HTML_DESCRIPTION" CLOB, 
	"UNDERSCORE_COLLECTION_TYPE" VARCHAR2(50) NOT NULL ENABLE, 
	"DISPLAYED_MEDIA_ID" NUMBER, 
	 CONSTRAINT "UNDERSCORECOLLECTION_PK" PRIMARY KEY ("UNDERSCORE_COLLECTION_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_UNDERSCORE_AGENT_ID" FOREIGN KEY ("UNDERSCORE_AGENT_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_DISPLAYED_MEDIA_ID" FOREIGN KEY ("DISPLAYED_MEDIA_ID")
	  REFERENCES "MEDIA" ("MEDIA_ID") ENABLE, 
	 CONSTRAINT "FK_UNDERSCORE_COLLECTION_TYPE" FOREIGN KEY ("UNDERSCORE_COLLECTION_TYPE")
	  REFERENCES "CTUNDERSCORE_COLLECTION_TYPE" ("UNDERSCORE_COLLECTION_TYPE") ENABLE
   ) ;
COMMENT ON TABLE "UNDERSCORE_COLLECTION" IS 'Entity to cluster arbitrary groupings of collection objects.  Intended use is to describe the set of material that at some point in time consisted of a coherent collection.  Often this represents the collection (collected and purchased) of a single researcher, sometimes it represents a collection held by another institution.   Classical examples are listed in the book Wheres the ____ collection, thus the name for this entity as underscore collection.';
COMMENT ON COLUMN "UNDERSCORE_COLLECTION"."UNDERSCORE_COLLECTION_ID" IS 'Surrogate numeric primary key';
COMMENT ON COLUMN "UNDERSCORE_COLLECTION"."COLLECTION_NAME" IS 'The name for this collection, e.g. Smith Collection.';
COMMENT ON COLUMN "UNDERSCORE_COLLECTION"."DESCRIPTION" IS 'Text description of this collection.';
COMMENT ON COLUMN "UNDERSCORE_COLLECTION"."UNDERSCORE_AGENT_ID" IS 'Deprecated.  The agent for which this is the collection of  (e.g. Smith for Smith Collection).';
COMMENT ON COLUMN "UNDERSCORE_COLLECTION"."MASK_FG" IS 'Flag to indicate if this record should be shown to the public or not';
COMMENT ON COLUMN "UNDERSCORE_COLLECTION"."HTML_DESCRIPTION" IS 'HTML markup description for the public page for the collection. ';
COMMENT ON COLUMN "UNDERSCORE_COLLECTION"."UNDERSCORE_COLLECTION_TYPE" IS 'Type of named group';
COMMENT ON COLUMN "UNDERSCORE_COLLECTION"."DISPLAYED_MEDIA_ID" IS 'One media object, expected to be a web displayable image, which is to represent the named group.';
