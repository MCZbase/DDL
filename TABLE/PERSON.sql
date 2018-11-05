
  CREATE TABLE "PERSON" 
   (	"PERSON_ID" NUMBER NOT NULL ENABLE, 
	"PREFIX" VARCHAR2(20 CHAR), 
	"LAST_NAME" VARCHAR2(80 CHAR) NOT NULL ENABLE, 
	"FIRST_NAME" VARCHAR2(40 CHAR), 
	"MIDDLE_NAME" VARCHAR2(40 CHAR), 
	"SUFFIX" VARCHAR2(20 CHAR), 
	"BIRTH_DATE" DATE, 
	"DEATH_DATE" DATE, 
	"OLDEDITED" CHAR(1 CHAR), 
	 CONSTRAINT "PKEY_PERSON" PRIMARY KEY ("PERSON_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CTSUFFIX" FOREIGN KEY ("SUFFIX")
	  REFERENCES "CTSUFFIX" ("SUFFIX") ENABLE, 
	 CONSTRAINT "FK_CTPREFIX" FOREIGN KEY ("PREFIX")
	  REFERENCES "CTPREFIX" ("PREFIX") ENABLE
   ) 