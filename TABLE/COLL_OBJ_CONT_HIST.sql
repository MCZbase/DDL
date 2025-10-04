
  CREATE TABLE "COLL_OBJ_CONT_HIST" 
   (	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"CONTAINER_ID" NUMBER NOT NULL ENABLE, 
	"INSTALLED_DATE" DATE NOT NULL ENABLE, 
	"CURRENT_CONTAINER_FG" NUMBER NOT NULL ENABLE, 
	 CONSTRAINT "FK_COLLOBJCONTHIST_CONTAINER" FOREIGN KEY ("CONTAINER_ID")
	  REFERENCES "CONTAINER" ("CONTAINER_ID") ENABLE
   ) ;
COMMENT ON TABLE "COLL_OBJ_CONT_HIST" IS 'Collection object container history.  The current storage location and past storage locations of collection objects. ';
COMMENT ON COLUMN "COLL_OBJ_CONT_HIST"."COLLECTION_OBJECT_ID" IS 'The collection object to that was or is stored in the container.';
COMMENT ON COLUMN "COLL_OBJ_CONT_HIST"."CONTAINER_ID" IS 'The container in which the collection object is or was stored.';
COMMENT ON COLUMN "COLL_OBJ_CONT_HIST"."INSTALLED_DATE" IS 'The date at which the collection object was recorded as having been placed in the container.';
COMMENT ON COLUMN "COLL_OBJ_CONT_HIST"."CURRENT_CONTAINER_FG" IS 'Flag indicating whether this is the current container for the collection object or a past container.  Domain: 0, 1,.  Note: All values are 1.';
