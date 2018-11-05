
  CREATE TABLE "COLLECTION" 
   (	"COLLECTION_CDE" VARCHAR2(10) NOT NULL ENABLE, 
	"INSTITUTION_ACRONYM" VARCHAR2(20 CHAR), 
	"DESCR" VARCHAR2(255 CHAR), 
	"COLLECTION" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"COLLECTION_ID" NUMBER NOT NULL ENABLE, 
	"WEB_LINK" VARCHAR2(4000 CHAR), 
	"WEB_LINK_TEXT" VARCHAR2(25 CHAR), 
	"CATNUM_PREF_FG" VARCHAR2(1 CHAR), 
	"CATNUM_SUFF_FG" VARCHAR2(1 CHAR), 
	"GENBANK_PRID" NUMBER, 
	"GENBANK_USERNAME" VARCHAR2(20 CHAR), 
	"GENBANK_PWD" VARCHAR2(20 CHAR), 
	"LOAN_POLICY_URL" VARCHAR2(255 CHAR), 
	"ALLOW_PREFIX_SUFFIX" NUMBER(22,0) NOT NULL ENABLE, 
	"GUID_PREFIX" VARCHAR2(20 CHAR), 
	"INSTITUTION" VARCHAR2(255 CHAR), 
	 CONSTRAINT "PK_COLLECTION_ID" PRIMARY KEY ("COLLECTION_ID")
  USING INDEX  ENABLE
   ) 