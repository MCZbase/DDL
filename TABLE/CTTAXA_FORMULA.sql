
  CREATE TABLE "CTTAXA_FORMULA" 
   (	"TAXA_FORMULA" VARCHAR2(25 CHAR) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000), 
	 CONSTRAINT "CTTAXA_FORMULA_PK" PRIMARY KEY ("TAXA_FORMULA")
  USING INDEX  ENABLE
   ) ;
COMMENT ON COLUMN "CTTAXA_FORMULA"."DESCRIPTION" IS 'Free text concerning the forumula.';
COMMENT ON COLUMN "CTTAXA_FORMULA"."TAXA_FORMULA" IS 'The formula with which one or more taxon names are composed with each other and with additional text in an identification.';
