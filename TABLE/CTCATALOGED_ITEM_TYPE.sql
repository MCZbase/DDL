
  CREATE TABLE "CTCATALOGED_ITEM_TYPE" 
   (	"CATALOGED_ITEM_TYPE" CHAR(2 CHAR), 
	"DESCRIPTION" VARCHAR2(4000 CHAR)
   ) 
  CREATE UNIQUE INDEX "PK_CTCATALOGED_ITEM_TYPE" ON "CTCATALOGED_ITEM_TYPE" ("CATALOGED_ITEM_TYPE") 
  
ALTER TABLE "CTCATALOGED_ITEM_TYPE" ADD CONSTRAINT "PK_CTCATALOGED_ITEM_TYPE" PRIMARY KEY ("CATALOGED_ITEM_TYPE")
  USING INDEX "PK_CTCATALOGED_ITEM_TYPE"  ENABLE;
COMMENT ON TABLE "CTCATALOGED_ITEM_TYPE" IS 'Controlled vocabulary for types of cataloged items.  Loosely corresponds to dwc:basisOfRecord with values broadly corresponding to Darwin Core classes.  However, cataloged items are cataloged vouchers of some sort and may be mixed lots rather than observations, and dwc:MaterialSample corresponds to specimen part rather than to cataloged item.';
COMMENT ON COLUMN "CTCATALOGED_ITEM_TYPE"."CATALOGED_ITEM_TYPE" IS 'Types of cataloged items';
COMMENT ON COLUMN "CTCATALOGED_ITEM_TYPE"."DESCRIPTION" IS 'Human readable statement about the type of cataloged item.';
