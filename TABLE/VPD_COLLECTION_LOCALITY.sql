
  CREATE TABLE "VPD_COLLECTION_LOCALITY" 
   (	"COLLECTION_ID" NUMBER NOT NULL ENABLE, 
	"LOCALITY_ID" NUMBER NOT NULL ENABLE, 
	"STALE_FG" NUMBER(1,0), 
	 CONSTRAINT "PK_VPD_COLLECTION_LOCALITY" PRIMARY KEY ("COLLECTION_ID", "LOCALITY_ID")
  USING INDEX  ENABLE
   ) 