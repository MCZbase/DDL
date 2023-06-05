
  CREATE TABLE "COLL_OBJECT" 
   (	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"COLL_OBJECT_TYPE" CHAR(2 CHAR) NOT NULL ENABLE, 
	"ENTERED_PERSON_ID" NUMBER NOT NULL ENABLE, 
	"COLL_OBJECT_ENTERED_DATE" DATE NOT NULL ENABLE, 
	"LAST_EDITED_PERSON_ID" NUMBER, 
	"LAST_EDIT_DATE" DATE, 
	"COLL_OBJ_DISPOSITION" VARCHAR2(40 CHAR), 
	"LOT_COUNT" NUMBER NOT NULL ENABLE, 
	"CONDITION" VARCHAR2(255 CHAR), 
	"FLAGS" VARCHAR2(20 CHAR), 
	"LOT_COUNT_MODIFIER" VARCHAR2(5 CHAR), 
	"FIX_ENTERED_DATE" DATE, 
	"CONDITION_REMARKS" VARCHAR2(4000), 
	 CONSTRAINT "PK_COLL_OBJECT" PRIMARY KEY ("COLLECTION_OBJECT_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CTCOLL_OBJECT_TYPE" FOREIGN KEY ("COLL_OBJECT_TYPE")
	  REFERENCES "CTCOLL_OBJECT_TYPE" ("COLL_OBJECT_TYPE") ENABLE, 
	 CONSTRAINT "FK_CTCOLL_OBJ_DISP" FOREIGN KEY ("COLL_OBJ_DISPOSITION")
	  REFERENCES "CTCOLL_OBJ_DISP" ("COLL_OBJ_DISPOSITION") ENABLE, 
	 CONSTRAINT "FK_COLL_OBJECT_EDITED_AGENT" FOREIGN KEY ("LAST_EDITED_PERSON_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_COLL_OBJECT_ENTERED_AGENT" FOREIGN KEY ("ENTERED_PERSON_ID")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE
   )  ENABLE ROW MOVEMENT 