
  CREATE TABLE "TAXON_CATEGORY" 
   (	"TAXON_CATEGORY_ID" NUMBER GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	"TAXON_NAME_ID" NUMBER NOT NULL ENABLE, 
	"TAXON_CATEGORY" VARCHAR2(255) NOT NULL ENABLE, 
	"CREATED_AGENT_ID" NUMBER, 
	"CREATED_TIMESTAMP" TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP NOT NULL ENABLE, 
	"LAST_MODIFIED" TIMESTAMP (6), 
	 CONSTRAINT "TAXON_CATEGORY_PK" PRIMARY KEY ("TAXON_CATEGORY_ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "FK1_TAXON_CATEGORY_TAXON" FOREIGN KEY ("TAXON_NAME_ID")
	  REFERENCES "TAXONOMY" ("TAXON_NAME_ID") ON DELETE CASCADE ENABLE, 
	 CONSTRAINT "FK_TAXON_CATEGORY" FOREIGN KEY ("TAXON_CATEGORY")
	  REFERENCES "CTTAXON_CATEGORY" ("TAXON_CATEGORY") ENABLE
   ) ;
COMMENT ON TABLE "TAXON_CATEGORY" IS 'Formal or informal categorization of taxon records.   Added to provide the functionality provided by specify-huh''s taxon.taxon_type{vascular plants,fungi,lichens, cryptogams, algae}.';
COMMENT ON COLUMN "TAXON_CATEGORY"."CREATED_AGENT_ID" IS 'Agent who created this taxon category record.';
COMMENT ON COLUMN "TAXON_CATEGORY"."CREATED_TIMESTAMP" IS 'Automatic.  Timestamp for when this record was created.';
COMMENT ON COLUMN "TAXON_CATEGORY"."TAXON_CATEGORY_ID" IS 'Surrogate numeric primary key';
COMMENT ON COLUMN "TAXON_CATEGORY"."TAXON_NAME_ID" IS 'The taxon name to which this category applies.';
COMMENT ON COLUMN "TAXON_CATEGORY"."TAXON_CATEGORY" IS 'A formal or informal category that applies to the specified taxon record.  May be a phylogenetic group such as fungi, or biological category that doesn''t map onto a single phylogenetic group such as lichens, or a grade such as land snails, or a non biological category such as grant work the taxon record is related to.';
