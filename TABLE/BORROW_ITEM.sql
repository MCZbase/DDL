
  CREATE TABLE "BORROW_ITEM" 
   (	"TRANSACTION_ID" NUMBER NOT NULL DISABLE, 
	"CATALOG_NUMBER" VARCHAR2(255 CHAR), 
	"SCI_NAME" VARCHAR2(255 CHAR), 
	"NO_OF_SPEC" VARCHAR2(20 CHAR), 
	"SPEC_PREP" VARCHAR2(100 CHAR), 
	"TYPE_STATUS" VARCHAR2(100 CHAR), 
	"COUNTRY_OF_ORIGIN" VARCHAR2(255 CHAR), 
	"OBJECT_REMARKS" VARCHAR2(2000 CHAR), 
	"BORROW_ITEM_ID" NUMBER
   ) ;
COMMENT ON TABLE "BORROW_ITEM" IS 'An item owned by another instution loaned to the MCZ by that instution, not to be accessioned into the MCZ''s collections with ownership retained by the loaning institution.';
COMMENT ON COLUMN "BORROW_ITEM"."TRANSACTION_ID" IS 'The borrow to which this item belongs.';
COMMENT ON COLUMN "BORROW_ITEM"."CATALOG_NUMBER" IS 'Catalog number, if any, assigned to this borrow item by the loaning institution.';
COMMENT ON COLUMN "BORROW_ITEM"."SCI_NAME" IS 'A scientific name associated with this borrowed item, expected to be the name provided on the loaning institution''s list of loaned items.';
COMMENT ON COLUMN "BORROW_ITEM"."NO_OF_SPEC" IS 'The number of specimens comprising the borrowed item.  ';
COMMENT ON COLUMN "BORROW_ITEM"."SPEC_PREP" IS 'Information about the part type and preservation mode of the borrowed item.';
COMMENT ON COLUMN "BORROW_ITEM"."TYPE_STATUS" IS 'Type status, if any for the borrowed item as asserted by the loaning institution.';
COMMENT ON COLUMN "BORROW_ITEM"."COUNTRY_OF_ORIGIN" IS 'The original country of origin of the borrowed item (distinct from the country of the loaning institution).';
COMMENT ON COLUMN "BORROW_ITEM"."OBJECT_REMARKS" IS 'Comments or notes concerning the borrowed item.';
COMMENT ON COLUMN "BORROW_ITEM"."BORROW_ITEM_ID" IS 'Surrogate numeric primary key';
