
  CREATE TABLE "PUBLICATION_ATTRIBUTES" 
   (	"PUBLICATION_ATTRIBUTE_ID" NUMBER NOT NULL ENABLE, 
	"PUBLICATION_ID" NUMBER NOT NULL ENABLE, 
	"PUBLICATION_ATTRIBUTE" VARCHAR2(60 CHAR) NOT NULL ENABLE, 
	"PUB_ATT_VALUE" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	 CONSTRAINT "PK_PUBLICATION_ATTRIBUTE_ID" PRIMARY KEY ("PUBLICATION_ATTRIBUTE_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_PUBATTR_CTPUBATTR" FOREIGN KEY ("PUBLICATION_ATTRIBUTE")
	  REFERENCES "CTPUBLICATION_ATTRIBUTE" ("PUBLICATION_ATTRIBUTE") ENABLE, 
	 CONSTRAINT "PUBLICATION_ATTRIBUTES_FK1" FOREIGN KEY ("PUBLICATION_ID")
	  REFERENCES "PUBLICATION" ("PUBLICATION_ID") ON DELETE CASCADE ENABLE
   ) 