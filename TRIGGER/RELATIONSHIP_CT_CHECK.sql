
  CREATE OR REPLACE TRIGGER "RELATIONSHIP_CT_CHECK" 
before UPDATE or INSERT ON biol_indiv_relations
for each row
declare
numrows number;
BEGIN
SELECT COUNT(*) INTO numrows FROM ctbiol_relations WHERE BIOL_INDIV_RELATIONSHIP = :NEW.BIOL_INDIV_RELATIONSHIP;
	IF (numrows = 0) THEN
		 raise_application_error(
	        -20001,
	        'Invalid BIOL_INDIV_RELATIONSHIP'
	      );
	END IF;
END;

ALTER TRIGGER "RELATIONSHIP_CT_CHECK" ENABLE