
  CREATE TABLE "CATALOGED_ITEM" 
   (	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"CAT_NUM" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"ACCN_ID" NUMBER NOT NULL ENABLE, 
	"COLLECTING_EVENT_ID" NUMBER NOT NULL ENABLE, 
	"COLLECTION_CDE" VARCHAR2(10) NOT NULL ENABLE, 
	"CATALOGED_ITEM_TYPE" CHAR(2) NOT NULL ENABLE, 
	"COLLECTION_ID" NUMBER NOT NULL ENABLE, 
	"CAT_NUM_PREFIX" VARCHAR2(60 CHAR), 
	"CAT_NUM_INTEGER" NUMBER NOT NULL ENABLE, 
	"CAT_NUM_SUFFIX" VARCHAR2(60 CHAR), 
	 CONSTRAINT "CK_CATITEM_CATNUM" CHECK ("CAT_NUM_INTEGER">0) ENABLE, 
	 CONSTRAINT "PK_CATALOGED_ITEM" PRIMARY KEY ("COLLECTION_OBJECT_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CAT_NUM_PREFIX" FOREIGN KEY ("CAT_NUM_PREFIX")
	  REFERENCES "CTCATALOG_NUMBER_PREFIX" ("CAT_NUM_PREFIX") ENABLE, 
	 CONSTRAINT "FK_CATITEM_COLLECTION" FOREIGN KEY ("COLLECTION_ID")
	  REFERENCES "COLLECTION" ("COLLECTION_ID") ENABLE, 
	 CONSTRAINT "FK_CATITEM_COLLEVENT" FOREIGN KEY ("COLLECTING_EVENT_ID")
	  REFERENCES "COLLECTING_EVENT" ("COLLECTING_EVENT_ID") ENABLE, 
	 CONSTRAINT "FK_CATITEM_COLLOBJECT" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "COLL_OBJECT" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "FK_CATITEM_ACCN" FOREIGN KEY ("ACCN_ID")
	  REFERENCES "ACCN" ("TRANSACTION_ID") ENABLE, 
	 CONSTRAINT "FK_CTCATALOGED_ITEM_TYPE" FOREIGN KEY ("CATALOGED_ITEM_TYPE")
	  REFERENCES "CTCATALOGED_ITEM_TYPE" ("CATALOGED_ITEM_TYPE") ENABLE
   ) 
  PARTITION BY LIST ("COLLECTION_ID") 
 (PARTITION "MCZ_HERP"  VALUES (1) , 
 PARTITION "MCZ_MAMM"  VALUES (2) , 
 PARTITION "MCZ_MALA"  VALUES (3) , 
 PARTITION "MCZ_FISH"  VALUES (4) , 
 PARTITION "MCZ_BIRD"  VALUES (5) , 
 PARTITION "MCZ_VP"  VALUES (6) , 
 PARTITION "MCZ_IP"  VALUES (7) , 
 PARTITION "MCZ_IZ"  VALUES (8) , 
 PARTITION "MCZ_ENT"  VALUES (9) , 
 PARTITION "MCZ_SC"  VALUES (10) , 
 PARTITION "MCZ_CRYO"  VALUES (11) , 
 PARTITION "MCZ_MCZ"  VALUES (12) , 
 PARTITION "MCZ_HERPOBS"  VALUES (13) )  ENABLE ROW MOVEMENT 