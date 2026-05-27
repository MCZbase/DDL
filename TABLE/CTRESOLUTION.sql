
  CREATE TABLE "CTRESOLUTION" 
   (	"RESOLUTION" VARCHAR2(50) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(4000), 
	 CONSTRAINT "CTRESOLUTION_PK" PRIMARY KEY ("RESOLUTION")
  USING INDEX  ENABLE
   ) ;
COMMENT ON TABLE "CTRESOLUTION" IS 'Controlled vocabulary for the resolution of an annotation issue/report.';
COMMENT ON COLUMN "CTRESOLUTION"."RESOLUTION" IS 'A controlled term describing how an annotation issue/report was resolved.';
COMMENT ON COLUMN "CTRESOLUTION"."DESCRIPTION" IS 'A definition for the resolution term.';
