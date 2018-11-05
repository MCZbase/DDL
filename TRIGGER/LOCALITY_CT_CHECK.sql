
  CREATE OR REPLACE TRIGGER "LOCALITY_CT_CHECK" 
before UPDATE or INSERT ON locality
for each row
declare
numrows number;
BEGIN
	IF (:new.orig_elev_units is not null) THEN
		SELECT COUNT(*) INTO numrows FROM ctorig_elev_units WHERE orig_elev_units = :NEW.orig_elev_units;
		IF (numrows = 0) THEN
			 raise_application_error(
		        -20001,
		        'Invalid orig_elev_units'
		      );
		END IF;
	END IF;
	IF (:new.DEPTH_UNITS is not null) THEN
		SELECT COUNT(*) INTO numrows FROM ctdepth_units WHERE DEPTH_UNITS = :NEW.DEPTH_UNITS;
		IF (numrows = 0) THEN
			 raise_application_error(
		        -20001,
		        'Invalid DEPTH_UNITS'
		      );
		END IF;
	END IF;
END;

ALTER TRIGGER "LOCALITY_CT_CHECK" ENABLE