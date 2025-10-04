
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
   ) ;
COMMENT ON TABLE "CTGUID_TYPE" IS 'Code table for types of globally unique identifiers.';
COMMENT ON COLUMN "CTGUID_TYPE"."APPLIES_TO" IS 'space delimited list of table.field names this guid type applies to.';
COMMENT ON COLUMN "CTGUID_TYPE"."PLACEHOLDER" IS 'placeholder to display as hint for data entry.';
COMMENT ON COLUMN "CTGUID_TYPE"."PATTERN_REGEX" IS 'regular expression to which correctly entered values for this guid type must conform.  Sould at least cover namespace.';
COMMENT ON COLUMN "CTGUID_TYPE"."RESOLVER_REGEX" IS 'regular expression to find pattern for replacement by resover_replacement to transform guid as entered to resolvalble IRI.  Leave null if guid is entered in resolvable form.';
COMMENT ON COLUMN "CTGUID_TYPE"."RESOLVER_REPLACEMENT" IS 'replacement for match on resolver_regex to convert guid of this type to a resolvable form.  Leave null if guid is entered in resolvable form.';
COMMENT ON COLUMN "CTGUID_TYPE"."SEARCH_URI" IS 'URI to search guid authority for resource by a relevant string.';
COMMENT ON COLUMN "CTGUID_TYPE"."GUID_TYPE" IS 'primary key, descriptor of the specific type of guid.';
COMMENT ON COLUMN "CTGUID_TYPE"."DESCRIPTION" IS 'description of this guid';
