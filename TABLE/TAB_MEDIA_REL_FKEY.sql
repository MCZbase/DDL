
  CREATE TABLE "TAB_MEDIA_REL_FKEY" 
   (	"MEDIA_RELATIONS_ID" NUMBER NOT NULL ENABLE, 
	"CFK_CATALOGED_ITEM" NUMBER, 
	"CFK_AGENT" NUMBER, 
	"CFK_ACCN" NUMBER(22,0), 
	"CFK_COLLECTING_EVENT" NUMBER(22,0), 
	"CFK_LOCALITY" NUMBER(22,0), 
	"CFK_MEDIA" NUMBER(22,0), 
	"CFK_PROJECT" NUMBER(22,0), 
	"CFK_PUBLICATION" NUMBER(22,0), 
	"CFK_TAXONOMY" NUMBER(22,0), 
	"CFK_PERMIT" NUMBER, 
	"CFK_DEACCESSION" NUMBER, 
	"CFK_LOAN" NUMBER, 
	"CFK_BORROW" NUMBER, 
	"CFK_UNDERSCORE_COLLECTION" NUMBER, 
	 CONSTRAINT "FK_TABMEDIARELFKEY_COLLEVENT" FOREIGN KEY ("CFK_COLLECTING_EVENT")
	  REFERENCES "COLLECTING_EVENT" ("COLLECTING_EVENT_ID") ENABLE, 
	 CONSTRAINT "FK_TABMEDIARELFKEY_ACCN" FOREIGN KEY ("CFK_ACCN")
	  REFERENCES "ACCN" ("TRANSACTION_ID") ENABLE, 
	 CONSTRAINT "FK_MR_AGENT" FOREIGN KEY ("CFK_AGENT")
	  REFERENCES "AGENT" ("AGENT_ID") ENABLE, 
	 CONSTRAINT "FK_TABMEDIARELFKEY_CATITEM" FOREIGN KEY ("CFK_CATALOGED_ITEM")
	  REFERENCES "CATALOGED_ITEM" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "FK_MR_PERMIT" FOREIGN KEY ("CFK_PERMIT")
	  REFERENCES "PERMIT" ("PERMIT_ID") ENABLE, 
	 CONSTRAINT "FK_MR_DEACCESSION" FOREIGN KEY ("CFK_DEACCESSION")
	  REFERENCES "DEACCESSION" ("TRANSACTION_ID") ENABLE, 
	 CONSTRAINT "FK_MR_LOAN" FOREIGN KEY ("CFK_LOAN")
	  REFERENCES "LOAN" ("TRANSACTION_ID") ENABLE, 
	 CONSTRAINT "FK_MR_BORROW" FOREIGN KEY ("CFK_BORROW")
	  REFERENCES "BORROW" ("TRANSACTION_ID") ENABLE, 
	 CONSTRAINT "FK_MR_UNDERSCORE_COLLECTION" FOREIGN KEY ("CFK_UNDERSCORE_COLLECTION")
	  REFERENCES "UNDERSCORE_COLLECTION" ("UNDERSCORE_COLLECTION_ID") ENABLE
   ) 