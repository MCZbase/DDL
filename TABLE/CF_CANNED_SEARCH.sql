
  CREATE TABLE "CF_CANNED_SEARCH" 
   (	"USER_ID" NUMBER NOT NULL ENABLE, 
	"SEARCH_NAME" VARCHAR2(60 CHAR) NOT NULL ENABLE, 
	"URL" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	"CANNED_ID" NUMBER NOT NULL ENABLE, 
	"EXECUTE" NUMBER DEFAULT 0, 
	 CONSTRAINT "CF_CANNED_SEARCH_PK" PRIMARY KEY ("CANNED_ID")
  USING INDEX  ENABLE
   ) 