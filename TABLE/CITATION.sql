
  CREATE TABLE "CITATION" 
   (	"PUBLICATION_ID" NUMBER NOT NULL ENABLE, 
	"COLLECTION_OBJECT_ID" NUMBER NOT NULL ENABLE, 
	"CITED_TAXON_NAME_ID" NUMBER NOT NULL ENABLE, 
	"CIT_CURRENT_FG" NUMBER NOT NULL ENABLE, 
	"OCCURS_PAGE_NUMBER" NUMBER, 
	"TYPE_STATUS" VARCHAR2(60), 
	"CITATION_REMARKS" VARCHAR2(4000), 
	"CITATION_TEXT" VARCHAR2(255 CHAR), 
	"REP_PUBLISHED_YEAR" NUMBER, 
	"CITATION_PAGE_URI" VARCHAR2(255 CHAR), 
	 CONSTRAINT "PK_CITATION" PRIMARY KEY ("COLLECTION_OBJECT_ID", "PUBLICATION_ID", "CITED_TAXON_NAME_ID")
  USING INDEX (CREATE UNIQUE INDEX "U_COLLOBJIDPUBIDTAXID" ON "CITATION" ("COLLECTION_OBJECT_ID", "PUBLICATION_ID", "CITED_TAXON_NAME_ID") 
  )  ENABLE, 
	 CONSTRAINT "FK_CITATION_CATITEM" FOREIGN KEY ("COLLECTION_OBJECT_ID")
	  REFERENCES "CATALOGED_ITEM" ("COLLECTION_OBJECT_ID") ENABLE, 
	 CONSTRAINT "FK_CITATION_PUBLICATION" FOREIGN KEY ("PUBLICATION_ID")
	  REFERENCES "PUBLICATION" ("PUBLICATION_ID") ENABLE, 
	 CONSTRAINT "FK_CITATION_TAXONOMY" FOREIGN KEY ("CITED_TAXON_NAME_ID")
	  REFERENCES "TAXONOMY" ("TAXON_NAME_ID") ENABLE, 
	 CONSTRAINT "FK_TYPE_STATUS" FOREIGN KEY ("TYPE_STATUS")
	  REFERENCES "CTCITATION_TYPE_STATUS" ("TYPE_STATUS") ENABLE
   ) ;
COMMENT ON TABLE "CITATION" IS 'Citations record the association of a taxon name with a cataloged item in a publication.';
COMMENT ON COLUMN "CITATION"."PUBLICATION_ID" IS 'The publication being cited';
COMMENT ON COLUMN "CITATION"."COLLECTION_OBJECT_ID" IS 'The collection object mentioned in the publication';
COMMENT ON COLUMN "CITATION"."CITED_TAXON_NAME_ID" IS 'The taxon name applied to the collection object in the publication.';
COMMENT ON COLUMN "CITATION"."CIT_CURRENT_FG" IS 'Deprecated?  Flag indicating whether this is a current citation or not.  Domain: 0, 1.   Almost all values are 1,  Not used in UI.';
COMMENT ON COLUMN "CITATION"."OCCURS_PAGE_NUMBER" IS 'The first page number in the publication on which the collection object is cited using the cited taxon name.';
COMMENT ON COLUMN "CITATION"."TYPE_STATUS" IS 'Primary, Secondary, or Voucher status, or other category of assertion about the cataloged item asserted by the publication.';
COMMENT ON COLUMN "CITATION"."CITATION_REMARKS" IS 'Comments or notes about the citation.';
COMMENT ON COLUMN "CITATION"."CITATION_TEXT" IS 'Text quoted from the citation.';
COMMENT ON COLUMN "CITATION"."REP_PUBLISHED_YEAR" IS 'Year that the portion of the publication containing the citation is reported to have been published.';
COMMENT ON COLUMN "CITATION"."CITATION_PAGE_URI" IS 'A URI at which a resource representing the page in the publication on which the collection object is cited occurs.';
