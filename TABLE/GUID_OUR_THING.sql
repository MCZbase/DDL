
  CREATE TABLE "GUID_OUR_THING" 
   (	"GUID_OUR_THING_ID" NUMBER NOT NULL ENABLE, 
	"TIMESTAMP_CREATED" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP NOT NULL ENABLE, 
	"TARGET_TABLE" VARCHAR2(20), 
	"CO_COLLECTION_OBJECT_ID" NUMBER, 
	"SP_COLLECTION_OBJECT_ID" NUMBER, 
	"TAXON_NAME_ID" NUMBER, 
	"RESOLVER_PREFIX" VARCHAR2(500), 
	"SCHEME" VARCHAR2(20), 
	"TYPE" VARCHAR2(20), 
	"AUTHORITY" VARCHAR2(50), 
	"LOCAL_IDENTIFIER" VARCHAR2(3000), 
	"ASSEMBLED_IDENTIFIER" VARCHAR2(3500), 
	"ASSEMBLED_RESOLVABLE" VARCHAR2(4000), 
	"ASSIGNED_BY_AGENT_ID" NUMBER, 
	"CREATED_BY_AGENT_ID" VARCHAR2(30), 
	"LAST_MODIFIED" TIMESTAMP (6), 
	"DISPOSITION" VARCHAR2(20) DEFAULT 'exists' NOT NULL ENABLE, 
	"GUID_IS_A" VARCHAR2(50), 
	"METADATA" CLOB, 
	"INTERNAL_FG" NUMBER(1,0) DEFAULT 1, 
	 CONSTRAINT "GUID_OUR_THING_PK" PRIMARY KEY ("GUID_OUR_THING_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "UNIQUE_GUID" UNIQUE ("ASSEMBLED_IDENTIFIER")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CO_COLL_OBJECT_ID" FOREIGN KEY ("CO_COLLECTION_OBJECT_ID")
	  REFERENCES "COLL_OBJECT" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "FK_SP_COLL_OBJECT_ID" FOREIGN KEY ("SP_COLLECTION_OBJECT_ID")
	  REFERENCES "SPECIMEN_PART" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "FK_TAXON_NAME_ID" FOREIGN KEY ("TAXON_NAME_ID")
	  REFERENCES "TAXONOMY" ("TAXON_NAME_ID") ENABLE
   ) ;
COMMENT ON TABLE "GUID_OUR_THING" IS 'Identifiers for things (data objects or physical objects) that the instution holds, assigned internally or externally. ';
COMMENT ON COLUMN "GUID_OUR_THING"."SP_COLLECTION_OBJECT_ID" IS 'The primary key value in the target table specimen_part  for the identified thing.  Expected to be an materialSampleID';
COMMENT ON COLUMN "GUID_OUR_THING"."TAXON_NAME_ID" IS 'The primary key value in the target table taxonomy  for the identified thing.  Expected to be some form of taxon identifier.';
COMMENT ON COLUMN "GUID_OUR_THING"."RESOLVER_PREFIX" IS 'A place where the identifier can be resolved, for arks, this is https://NMA/ the protocol and name mapping authority.';
COMMENT ON COLUMN "GUID_OUR_THING"."SCHEME" IS 'the scheme for the identifier, e.g. urn:, ark:';
COMMENT ON COLUMN "GUID_OUR_THING"."TYPE" IS 'Namspace identifier for a urn, e.g. uuid:.';
COMMENT ON COLUMN "GUID_OUR_THING"."AUTHORITY" IS 'For arks, the name assigning number authority';
COMMENT ON COLUMN "GUID_OUR_THING"."LOCAL_IDENTIFIER" IS 'The unique part of the identifier.  For arks, the NAME, for urns, the NS namspace specific part.';
COMMENT ON COLUMN "GUID_OUR_THING"."ASSEMBLED_IDENTIFIER" IS 'The fully assembled identifier string, without a resolver prefix.';
COMMENT ON COLUMN "GUID_OUR_THING"."ASSEMBLED_RESOLVABLE" IS 'The fully assembled resolvable identifier';
COMMENT ON COLUMN "GUID_OUR_THING"."ASSIGNED_BY_AGENT_ID" IS 'Agent who assigned this identifier, us or an external entity.';
COMMENT ON COLUMN "GUID_OUR_THING"."CREATED_BY_AGENT_ID" IS 'Agent who created this record';
COMMENT ON COLUMN "GUID_OUR_THING"."LAST_MODIFIED" IS 'timestamp of last modification date';
COMMENT ON COLUMN "GUID_OUR_THING"."DISPOSITION" IS 'Disposition of the object that this guid is for, default is exists, could be deleed or merged.';
COMMENT ON COLUMN "GUID_OUR_THING"."GUID_IS_A" IS 'The context in which this guid would be used, occurrenceID, materalSampleID, taxonID, etc.';
COMMENT ON COLUMN "GUID_OUR_THING"."METADATA" IS 'A metadata record for the subject of the guid.';
COMMENT ON COLUMN "GUID_OUR_THING"."INTERNAL_FG" IS 'Flag indicating whether or not the identifier was internally assigned. 0=external assignment, 1=default internal assignment.';
COMMENT ON COLUMN "GUID_OUR_THING"."GUID_OUR_THING_ID" IS 'surrogate_numeric_primary_key';
COMMENT ON COLUMN "GUID_OUR_THING"."TIMESTAMP_CREATED" IS 'Date and time the record for this identifier was created.';
COMMENT ON COLUMN "GUID_OUR_THING"."TARGET_TABLE" IS 'The table holding the record of the identified thing.';
COMMENT ON COLUMN "GUID_OUR_THING"."CO_COLLECTION_OBJECT_ID" IS 'The primary key value in the target table collection_object which takes an identification for the identified thing.  Expected to be an occurrenceID';
