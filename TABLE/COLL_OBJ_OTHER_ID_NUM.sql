
  CREATE TABLE "COLL_OBJ_OTHER_ID_NUM" 
   (	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"OTHER_ID_TYPE" VARCHAR2(75 CHAR) NOT NULL ENABLE, 
	"OTHER_ID_PREFIX" VARCHAR2(100 CHAR), 
	"OTHER_ID_NUMBER" NUMBER, 
	"OTHER_ID_SUFFIX" VARCHAR2(60 CHAR), 
	"DISPLAY_VALUE" VARCHAR2(255 CHAR), 
	"COLL_OBJ_OTHER_ID_NUM_ID" NUMBER(*,0) NOT NULL ENABLE, 
	 CONSTRAINT "FK_COLLOBJOTHERIDNUM_CATITEM" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "CATALOGED_ITEM" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "FK_CTCOLL_OTHER_ID_TYPE" FOREIGN KEY ("OTHER_ID_TYPE")
	  REFERENCES "CTCOLL_OTHER_ID_TYPE" ("OTHER_ID_TYPE") ENABLE
   ) 
  CREATE UNIQUE INDEX "PK_COLL_OBJ_OTHER_ID_NUM_ID" ON "COLL_OBJ_OTHER_ID_NUM" ("COLL_OBJ_OTHER_ID_NUM_ID") 
  
ALTER TABLE "COLL_OBJ_OTHER_ID_NUM" ADD CONSTRAINT "PK_COLL_OBJ_OTHER_ID_NUM_ID" PRIMARY KEY ("COLL_OBJ_OTHER_ID_NUM_ID")
  USING INDEX "PK_COLL_OBJ_OTHER_ID_NUM_ID"  ENABLE;
COMMENT ON TABLE "COLL_OBJ_OTHER_ID_NUM" IS 'Other numbers applied to collection objects that identify them in various ways, not always uniquely, or relate them to other data.';
COMMENT ON COLUMN "COLL_OBJ_OTHER_ID_NUM"."COLLECTION_OBJECT_ID" IS 'The collection object to which this other number applies.';
COMMENT ON COLUMN "COLL_OBJ_OTHER_ID_NUM"."OTHER_ID_TYPE" IS 'The type of the other number';
COMMENT ON COLUMN "COLL_OBJ_OTHER_ID_NUM"."OTHER_ID_PREFIX" IS 'An alphanumeric prefix for the other number.  If a separator is needed between the prefix and the number, it must be included in the prefix.';
COMMENT ON COLUMN "COLL_OBJ_OTHER_ID_NUM"."OTHER_ID_NUMBER" IS 'The numeric portion of the other number.';
COMMENT ON COLUMN "COLL_OBJ_OTHER_ID_NUM"."OTHER_ID_SUFFIX" IS 'An alphanumeric prefix for the other number.  If a separator is needed between the other umber and the suffix, it must be included in the suffix.';
COMMENT ON COLUMN "COLL_OBJ_OTHER_ID_NUM"."DISPLAY_VALUE" IS 'The value of the other number, assembled automatically by concatenationg other-id_prefix, other_id_number, and other_id_suffix.   No additional characters are included in the concatenation.';
COMMENT ON COLUMN "COLL_OBJ_OTHER_ID_NUM"."COLL_OBJ_OTHER_ID_NUM_ID" IS 'Surrogate Numeric Primary Key';
