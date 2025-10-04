
  CREATE TABLE "CTGEOLOGY_ATTRIBUTES" 
   (	"GEOLOGY_ATTRIBUTE" VARCHAR2(255 CHAR) NOT NULL ENABLE, 
	"TYPE" VARCHAR2(50) DEFAULT 'chronostratigraphic' NOT NULL ENABLE, 
	"ORDINAL" NUMBER DEFAULT 50 NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000), 
	 CONSTRAINT "CTGEOLOGY_ATTRIBUTE_NEW_PK" PRIMARY KEY ("GEOLOGY_ATTRIBUTE")
  USING INDEX  ENABLE
   ) ;
COMMENT ON TABLE "CTGEOLOGY_ATTRIBUTES" IS 'See ctgeology_attribute for a view sorted by ordinal.';
COMMENT ON COLUMN "CTGEOLOGY_ATTRIBUTES"."GEOLOGY_ATTRIBUTE" IS 'The geological attribute';
COMMENT ON COLUMN "CTGEOLOGY_ATTRIBUTES"."TYPE" IS 'The type of the geological attribute (chronostratigraphic, lithostratigraphic, lithologic)';
COMMENT ON COLUMN "CTGEOLOGY_ATTRIBUTES"."ORDINAL" IS 'Order in which to list these terms in picklists and other controls.';
COMMENT ON COLUMN "CTGEOLOGY_ATTRIBUTES"."DESCRIPTION" IS 'A description or definition of the geology attribute.';
