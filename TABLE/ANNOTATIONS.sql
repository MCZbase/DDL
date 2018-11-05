
  CREATE TABLE "ANNOTATIONS" 
   (	"ANNOTATION_ID" NUMBER NOT NULL ENABLE, 
	"ANNOTATE_DATE" DATE DEFAULT SYSDATE NOT NULL ENABLE, 
	"CF_USERNAME" VARCHAR2(255 CHAR), 
	"COLLECTION_OBJECT_ID" NUMBER, 
	"TAXON_NAME_ID" NUMBER, 
	"PROJECT_ID" NUMBER, 
	"PUBLICATION_ID" NUMBER, 
	"ANNOTATION" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"REVIEWER_AGENT_ID" NUMBER, 
	"REVIEWED_FG" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	"REVIEWER_COMMENT" VARCHAR2(255 CHAR)
   ) 