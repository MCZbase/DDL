
  CREATE TABLE "IDENTIFICATION_TAXONOMY" 
   (	"IDENTIFICATION_ID" NUMBER NOT NULL ENABLE, 
	"TAXON_NAME_ID" NUMBER NOT NULL ENABLE, 
	"VARIABLE" CHAR(1 CHAR), 
	 CONSTRAINT "FK_IDTAXONOMY_TAXONOMY" FOREIGN KEY ("TAXON_NAME_ID")
	  REFERENCES "TAXONOMY" ("TAXON_NAME_ID") ENABLE, 
	 CONSTRAINT "FK_IDTAXONOMY_IDENTIFICATION" FOREIGN KEY ("IDENTIFICATION_ID")
	  REFERENCES "IDENTIFICATION" ("IDENTIFICATION_ID") ENABLE
   ) ;
COMMENT ON TABLE "IDENTIFICATION_TAXONOMY" IS 'Associative entity linking taxonomy records to identifications.   Weakly keyed on identification_id, taxon_name_id and variable.  Variable matches a capital letter in the taxa_formula of an identification.   One identification can be related to one to many taxonomy records, where each element (captial letter) of the taxon formula (identification.taxa_formula) is matched to a taxon (taxonomy.taxon_name_id) through the variable (identification_taxonomy.variable) and the taxon_name_id (identification_taxonomy.taxon_name_id).';
COMMENT ON COLUMN "IDENTIFICATION_TAXONOMY"."IDENTIFICATION_ID" IS 'Identification in which the taxon name is used in the taxa_formula in the location identified by variable.';
COMMENT ON COLUMN "IDENTIFICATION_TAXONOMY"."TAXON_NAME_ID" IS 'Taxon the name of which is used in the identification in the location specified by the position of variable in taxa_formula.';
COMMENT ON COLUMN "IDENTIFICATION_TAXONOMY"."VARIABLE" IS 'Position (specified by a captial letter) in taxa_formula where the scientific name of the taxon in taxon_name_id is used in the identification specific by identification_id.';
