
  CREATE TABLE "GEOG_AUTH_REC" 
   (	"GEOG_AUTH_REC_ID" NUMBER NOT NULL ENABLE, 
	"CONTINENT_OCEAN" VARCHAR2(70 CHAR), 
	"COUNTRY" VARCHAR2(70 CHAR), 
	"STATE_PROV" VARCHAR2(75 CHAR), 
	"COUNTY" VARCHAR2(50 CHAR), 
	"QUAD" VARCHAR2(30 CHAR), 
	"FEATURE" VARCHAR2(50 CHAR), 
	"ISLAND" VARCHAR2(50 CHAR), 
	"ISLAND_GROUP" VARCHAR2(50 CHAR), 
	"SEA" VARCHAR2(50 CHAR), 
	"VALID_CATALOG_TERM_FG" NUMBER(3,0) NOT NULL ENABLE, 
	"SOURCE_AUTHORITY" VARCHAR2(45 CHAR) NOT NULL ENABLE, 
	"HIGHER_GEOG" VARCHAR2(255 CHAR), 
	"OCEAN_REGION" VARCHAR2(50 CHAR), 
	"OCEAN_SUBREGION" VARCHAR2(50 CHAR), 
	"WATER_FEATURE" VARCHAR2(50), 
	"WKT_POLYGON" CLOB, 
	"HIGHERGEOGRAPHYID_GUID_TYPE" VARCHAR2(255), 
	"HIGHERGEOGRAPHYID" VARCHAR2(900), 
	"CURATED_FG" NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE, 
	"MANAGEMENT_REMARKS" VARCHAR2(4000), 
	"SDO_POLYGON" "SDO_GEOMETRY"
   ) 
 VARRAY "SDO_POLYGON"."SDO_ELEM_INFO" STORE AS SECUREFILE LOB 
 VARRAY "SDO_POLYGON"."SDO_ORDINATES" STORE AS SECUREFILE LOB 
  CREATE UNIQUE INDEX "PK_GEOG_AUTH_REC" ON "GEOG_AUTH_REC" ("GEOG_AUTH_REC_ID") 
  
ALTER TABLE "GEOG_AUTH_REC" ADD CONSTRAINT "PKEY_GEOG_AUTH_REC" PRIMARY KEY ("GEOG_AUTH_REC_ID")
  USING INDEX "PK_GEOG_AUTH_REC"  ENABLE;
COMMENT ON TABLE "GEOG_AUTH_REC" IS 'Authority table for higher geographies into which localities are placed.  By design, inconsistent heiriarchies can be stored in this structure, allowing different collections to manage higher geographies independently.  Consistency is maintained by central management of the higher geography authority and data cleanup.   Concepts in the higher geography are filled in heirarchically to the appropriate level for land or water geographies, e.g. continent/country/state_prov/county/feature, or ocean/ocean region/ocean subregion/sea/water feature.  ';
COMMENT ON COLUMN "GEOG_AUTH_REC"."GEOG_AUTH_REC_ID" IS 'Surrogate numeric primary key.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."CONTINENT_OCEAN" IS 'Continent or Ocean for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."COUNTRY" IS 'Country level entity for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."STATE_PROV" IS 'Primary division of a country for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."COUNTY" IS 'Secondary division of a country for the higher geography.  Does not include the word County for counties.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."QUAD" IS 'Name of topographic quadrangle for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."FEATURE" IS 'Land feature for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."ISLAND" IS 'Island for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."ISLAND_GROUP" IS 'Named group of islands for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."SEA" IS 'Named sea for the higher geography, below ocean subregion, above water feature.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."VALID_CATALOG_TERM_FG" IS 'Flag indicating if this higher geography can be used in data entry: (1) yes, (0) no.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."SOURCE_AUTHORITY" IS 'Authoritative source for the information in the higher geography record.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."HIGHER_GEOG" IS 'Automatic, the assembled higher geography as a colon separated string.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."OCEAN_REGION" IS 'Ocean region for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."OCEAN_SUBREGION" IS 'Ocean subregion for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."WATER_FEATURE" IS 'Water feature below seay for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."WKT_POLYGON" IS 'GIS shape for the higher geography.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."HIGHERGEOGRAPHYID_GUID_TYPE" IS 'type of identifier used in HIGHERGEOGRAPHYID';
COMMENT ON COLUMN "GEOG_AUTH_REC"."HIGHERGEOGRAPHYID" IS 'dwc:higherGeographyID, a guid for the geographic region represented by the geog_auth_rec record.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."CURATED_FG" IS 'Marker for management of higher geographies indicating that record has been curated as much as possible.';
COMMENT ON COLUMN "GEOG_AUTH_REC"."MANAGEMENT_REMARKS" IS 'Internal remarks for users with manage_transactions role concerning curation of the record.';
