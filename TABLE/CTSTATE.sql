
  CREATE TABLE "CTSTATE" 
   (	"STATE" VARCHAR2(50) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000), 
	"STATE_CURIE" VARCHAR2(50), 
	 CONSTRAINT "CTSTATE_PK" PRIMARY KEY ("STATE")
  USING INDEX  ENABLE
   ) ;
COMMENT ON TABLE "CTSTATE" IS 'Controlled vocabulary for the workflow state of an annotation when treated as an issue/report.';
COMMENT ON COLUMN "CTSTATE"."STATE" IS 'A controlled term describing the workflow state of an annotation issue/report.';
COMMENT ON COLUMN "CTSTATE"."DESCRIPTION" IS 'A definition for the state term.';
COMMENT ON COLUMN "CTSTATE"."STATE_CURIE" IS 'A CURIE for an ontology term corresponding to the state, for example oslc_cm:Closed.';
