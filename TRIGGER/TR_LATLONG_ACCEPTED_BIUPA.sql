
  CREATE OR REPLACE TRIGGER "TR_LATLONG_ACCEPTED_BIUPA" 
BEFORE INSERT OR UPDATE ON LAT_LONG
FOR EACH ROW
DECLARE 
    numrows NUMBER;
    pragma autonomous_transaction;
BEGIN
    SELECT count(*) INTO numrows
    FROM lat_long 
    WHERE locality_id = :new.locality_id 
    AND accepted_lat_long_fg = 1;
	
    IF numrows > 0 AND :new.accepted_lat_long_fg = 1 THEN
    raise_application_error(
        -20001,
        'Accepted lat/long coordinates already exist for this locality.');
    END IF;
END;

ALTER TRIGGER "TR_LATLONG_ACCEPTED_BIUPA" ENABLE