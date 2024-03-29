
  CREATE TABLE "PUBLICATION" 
   (	"PUBLICATION_ID" NUMBER NOT NULL ENABLE, 
	"PUBLISHED_YEAR" NUMBER, 
	"PUBLICATION_TYPE" VARCHAR2(21 CHAR) NOT NULL ENABLE, 
	"PUBLICATION_LOC" VARCHAR2(255 CHAR), 
	"PUBLICATION_TITLE" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	"PUBLICATION_REMARKS" VARCHAR2(1000 CHAR), 
	"IS_PEER_REVIEWED_FG" NUMBER(22,0) NOT NULL ENABLE, 
	"DOI" VARCHAR2(4000), 
	"LAST_UPDATE_DATE" TIMESTAMP (6), 
	 CONSTRAINT "CK_PEER_FLAG" CHECK (is_peer_reviewed_fg IN (0,1)) ENABLE, 
	 CONSTRAINT "PK_PUBLICATION" PRIMARY KEY ("PUBLICATION_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_CTPUBLICATION_TYPE" FOREIGN KEY ("PUBLICATION_TYPE")
	  REFERENCES "CTPUBLICATION_TYPE" ("PUBLICATION_TYPE") ENABLE
   ) 