
  CREATE TABLE "CF_FORM_PERMISSIONS" 
   (	"KEY" NUMBER NOT NULL ENABLE, 
	"FORM_PATH" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"ROLE_NAME" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	 CONSTRAINT "CF_FORM_PERMISSIONS_PK" PRIMARY KEY ("KEY")
  USING INDEX  ENABLE
   ) 