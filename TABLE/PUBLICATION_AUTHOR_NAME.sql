
  CREATE TABLE "PUBLICATION_AUTHOR_NAME" 
   (	"PUBLICATION_ID" NUMBER NOT NULL ENABLE, 
	"AGENT_NAME_ID" NUMBER NOT NULL ENABLE, 
	"AUTHOR_POSITION" NUMBER NOT NULL ENABLE, 
	"AUTHOR_ROLE" VARCHAR2(60 CHAR) NOT NULL ENABLE, 
	"PUBLICATION_AUTHOR_NAME_ID" NUMBER(22,0) NOT NULL ENABLE, 
	 CONSTRAINT "PK_PUBLICATION_AUTHOR_NAME" PRIMARY KEY ("PUBLICATION_AUTHOR_NAME_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK_AUTHOR_ROLE" FOREIGN KEY ("AUTHOR_ROLE")
	  REFERENCES "CTAUTHOR_ROLE" ("AUTHOR_ROLE") ENABLE, 
	 CONSTRAINT "FK_PUBAUTHNAME_AGENTNAME" FOREIGN KEY ("AGENT_NAME_ID")
	  REFERENCES "AGENT_NAME" ("AGENT_NAME_ID") ENABLE, 
	 CONSTRAINT "FK_PUBAUTHNAME_PUBLICATION" FOREIGN KEY ("PUBLICATION_ID")
	  REFERENCES "PUBLICATION" ("PUBLICATION_ID") ENABLE
   ) 