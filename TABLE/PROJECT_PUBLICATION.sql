
  CREATE TABLE "PROJECT_PUBLICATION" 
   (	"PROJECT_ID" NUMBER NOT NULL ENABLE, 
	"PUBLICATION_ID" NUMBER NOT NULL ENABLE, 
	"PROJECT_PUBLICATION_REMARKS" VARCHAR2(255 CHAR), 
	 CONSTRAINT "PROJECT_PUBLICATION_FK1" FOREIGN KEY ("PUBLICATION_ID")
	  REFERENCES "PUBLICATION" ("PUBLICATION_ID") ENABLE, 
	 CONSTRAINT "PROJECT_PUBLICATION_FK2" FOREIGN KEY ("PROJECT_ID")
	  REFERENCES "PROJECT" ("PROJECT_ID") ENABLE
   ) 