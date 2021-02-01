
  CREATE TABLE "CTGUID_TYPE" 
   (	"GUID_TYPE" VARCHAR2(255) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(900), 
	"APPLIES_TO" VARCHAR2(255) NOT NULL ENABLE, 
	"PLACEHOLDER" VARCHAR2(100), 
	"PATTERN_REGEX" VARCHAR2(900) DEFAULT '/.*/' NOT NULL ENABLE, 
	"RESOLVER_REGEX" VARCHAR2(900), 
	"RESOLVER_REPLACEMENT" VARCHAR2(900), 
	"SEARCH_URI" VARCHAR2(255), 
	 CONSTRAINT "CTGUID_TYPE_PK" PRIMARY KEY ("GUID_TYPE")
  USING INDEX  ENABLE
   ) 