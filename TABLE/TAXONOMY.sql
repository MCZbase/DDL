
  CREATE TABLE "TAXONOMY" 
   (	"TAXON_NAME_ID" NUMBER NOT NULL ENABLE, 
	"PHYLCLASS" VARCHAR2(40 CHAR), 
	"PHYLORDER" VARCHAR2(30 CHAR), 
	"SUBORDER" VARCHAR2(30 CHAR), 
	"FAMILY" VARCHAR2(80 CHAR), 
	"SUBFAMILY" VARCHAR2(50 CHAR), 
	"GENUS" VARCHAR2(50 CHAR), 
	"SUBGENUS" VARCHAR2(20 CHAR), 
	"SPECIES" VARCHAR2(40 CHAR), 
	"SUBSPECIES" VARCHAR2(40 CHAR), 
	"VALID_CATALOG_TERM_FG" NUMBER NOT NULL ENABLE, 
	"SOURCE_AUTHORITY" VARCHAR2(100) NOT NULL ENABLE, 
	"FULL_TAXON_NAME" VARCHAR2(240 CHAR) NOT NULL ENABLE, 
	"SCIENTIFIC_NAME" VARCHAR2(110 CHAR) NOT NULL ENABLE, 
	"AUTHOR_TEXT" VARCHAR2(100 CHAR), 
	"TRIBE" VARCHAR2(30 CHAR), 
	"INFRASPECIFIC_RANK" VARCHAR2(10 CHAR), 
	"TAXON_REMARKS" VARCHAR2(4000 CHAR), 
	"PHYLUM" VARCHAR2(30 CHAR), 
	"SUPERFAMILY" VARCHAR2(50 CHAR), 
	"SUBPHYLUM" VARCHAR2(50 CHAR), 
	"SUBCLASS" VARCHAR2(50 CHAR), 
	"KINGDOM" VARCHAR2(255 CHAR), 
	"NOMENCLATURAL_CODE" VARCHAR2(255 CHAR), 
	"INFRASPECIFIC_AUTHOR" VARCHAR2(255 CHAR), 
	"INFRAORDER" VARCHAR2(100 CHAR), 
	"SUPERORDER" VARCHAR2(100 CHAR), 
	"DIVISION" VARCHAR2(100 CHAR), 
	"SUBDIVISION" VARCHAR2(100 CHAR), 
	"SUPERCLASS" VARCHAR2(100 CHAR), 
	"DISPLAY_NAME" VARCHAR2(255 CHAR), 
	"TAXON_STATUS" VARCHAR2(60 CHAR), 
	"GUID" VARCHAR2(255), 
	"INFRACLASS" VARCHAR2(100), 
	"SUBSECTION" VARCHAR2(50), 
	"TAXONID_GUID_TYPE" VARCHAR2(255), 
	"TAXONID" VARCHAR2(900), 
	"SCIENTIFICNAMEID_GUID_TYPE" VARCHAR2(255), 
	"SCIENTIFICNAMEID" VARCHAR2(900), 
	"YEAR_OF_PUBLICATION" VARCHAR2(20), 
	"ZOOLOGICAL_CHANGED_COMBINATION" NUMBER, 
	 CONSTRAINT "FK_TAXON_STATUS" FOREIGN KEY ("TAXON_STATUS")
	  REFERENCES "CTTAXON_STATUS" ("TAXON_STATUS") ENABLE
   )  ENABLE ROW MOVEMENT 
  CREATE UNIQUE INDEX "PK_TAXONOMY" ON "TAXONOMY" ("TAXON_NAME_ID") 
  
ALTER TABLE "TAXONOMY" ADD CONSTRAINT "PK_TAXONOMY" PRIMARY KEY ("TAXON_NAME_ID")
  USING INDEX "PK_TAXONOMY"  ENABLE;
COMMENT ON TABLE "TAXONOMY" IS 'A record concerning a taxon including the name for the taxon, its authorship, its classification, and authoritative sources of information about the taxon.   Higher classifications may be incomplete, and by design, may be inconsistent.   The design intent of the flat taxonomy table is to allow different collections to support different higher classifications, e.g.  a malacology department and an invertebrate paleontology department might choose to use different higher classification schemes for molluscs.   In this model, consistency in higher classification as a finding aid is achieved through consensus and data cleanup, but not enforced by the data structure.   In MCZbase, GUIDs are all external, as the MCZ does not consider itself as maintaining a nomenclatural or taxonomic authority, just local database records that may be linked to other taxonomic or nomenclatural authorities by their guids.';
COMMENT ON COLUMN "TAXONOMY"."TAXON_NAME_ID" IS 'Surrogate numeric primary key.';
COMMENT ON COLUMN "TAXONOMY"."PHYLCLASS" IS 'Taxonomic class into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."PHYLORDER" IS 'Taxonomic order into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."SUBORDER" IS 'Taxonomic suborder into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."FAMILY" IS 'Taxonomic Family into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."SUBFAMILY" IS 'Taxonomic subfamily into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."GENUS" IS 'Taxonomic genus into which the taxon is placed, or the generic epithet for the taxon.';
COMMENT ON COLUMN "TAXONOMY"."SUBGENUS" IS 'The subgeneric epithet for the taxon, without parenthesies.';
COMMENT ON COLUMN "TAXONOMY"."SPECIES" IS 'Specific epithet part of the taxon name, if of species rank or lower.';
COMMENT ON COLUMN "TAXONOMY"."SUBSPECIES" IS 'Subspecific epithet part of the scientific name if the taxon is of rank subspecies or lower.';
COMMENT ON COLUMN "TAXONOMY"."VALID_CATALOG_TERM_FG" IS 'Flag indicating whether a taxon record is accepted by the bulkloader (1) or not (0).';
COMMENT ON COLUMN "TAXONOMY"."SOURCE_AUTHORITY" IS 'The authority from which the taxon record was derived.';
COMMENT ON COLUMN "TAXONOMY"."FULL_TAXON_NAME" IS 'Automatic.  Space separated list of the classification and all parts of the name of the taxon, excluding authorship.  ';
COMMENT ON COLUMN "TAXONOMY"."SCIENTIFIC_NAME" IS 'The scientific name of the taxon.';
COMMENT ON COLUMN "TAXONOMY"."AUTHOR_TEXT" IS 'Authorship string for the scientific name.';
COMMENT ON COLUMN "TAXONOMY"."TRIBE" IS 'Taxonomic tribe into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."INFRASPECIFIC_RANK" IS 'Rank marker to apply to the subspecific epithet if the taxon is of rank below subspecies.';
COMMENT ON COLUMN "TAXONOMY"."TAXON_REMARKS" IS 'Free text assertions concerning the taxon.';
COMMENT ON COLUMN "TAXONOMY"."PHYLUM" IS 'Taxonomic phylum into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."SUPERFAMILY" IS 'Taxonomic superfamily into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."SUBPHYLUM" IS 'Taxonomic subphylum into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."SUBCLASS" IS 'Taxonomic subclass into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."KINGDOM" IS 'Taxonomic kingdom into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."NOMENCLATURAL_CODE" IS 'The code of nomenclature whos rules govern the formulation of the taxon name (ICZN, ICNapf), or non-compliant if the name is in a historical form with an orthography not compliant with the current rules.';
COMMENT ON COLUMN "TAXONOMY"."INFRASPECIFIC_AUTHOR" IS 'For ICNapf (botanical) names of below the species rank, the authorship string for the infraspecific part of the name.  ';
COMMENT ON COLUMN "TAXONOMY"."INFRAORDER" IS 'Taxonomic infraorder into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."SUPERORDER" IS 'Taxonomic superorder into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."DIVISION" IS 'For ICNafp (botanical) names, the taxonomic rank equivalent to phylum.';
COMMENT ON COLUMN "TAXONOMY"."SUBDIVISION" IS 'For ICNafp (botanical) names, the taxonomic rank equivalent to subphylum.';
COMMENT ON COLUMN "TAXONOMY"."SUPERCLASS" IS 'Taxonomic superclass into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."DISPLAY_NAME" IS 'Automatic.  Scientific name for display in html markup, with italics where appropriate, Does not include authorship string.';
COMMENT ON COLUMN "TAXONOMY"."TAXON_STATUS" IS 'Nomenclatural status for the taxon record if unavailable.  Actionable, prevents italiciation of display name.';
COMMENT ON COLUMN "TAXONOMY"."GUID" IS 'Unused.  Could hold a guid for the taxon record, if the institution considers itself an authority for the taxon record.';
COMMENT ON COLUMN "TAXONOMY"."INFRACLASS" IS 'Taxonomic infraclass into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."SUBSECTION" IS 'Taxonomic subsection into which the taxon is placed.';
COMMENT ON COLUMN "TAXONOMY"."TAXONID_GUID_TYPE" IS 'type of identifier used in taxonid';
COMMENT ON COLUMN "TAXONOMY"."TAXONID" IS 'dwc:taxonID, a guid for the taxon record.';
COMMENT ON COLUMN "TAXONOMY"."SCIENTIFICNAMEID_GUID_TYPE" IS 'type of identifier in scientificnameid';
COMMENT ON COLUMN "TAXONOMY"."SCIENTIFICNAMEID" IS 'dwc:scientificNameID, guid for the nomenclatural act on which the taxon found in scientific_name is based.';
COMMENT ON COLUMN "TAXONOMY"."YEAR_OF_PUBLICATION" IS 'Year part of the zoological authorship string, year in which the taxon name was published.';
COMMENT ON COLUMN "TAXONOMY"."ZOOLOGICAL_CHANGED_COMBINATION" IS 'Flag indicating if zoological name represents a changed conbination, and thus has the authorship string enclosed in parenthesies.';
