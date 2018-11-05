
  CREATE OR REPLACE TRIGGER "COLL_OBJECT_CT_CHECK" 
before UPDATE or INSERT ON coll_object
for each row
declare
numrows number;
BEGIN
	SELECT COUNT(*) INTO numrows FROM ctcoll_obj_disp WHERE coll_obj_disposition = :NEW.coll_obj_disposition;
	IF (numrows = 0) THEN
		 raise_application_error(
	        -20001,
	        'Invalid coll_obj_disposition: ' || :NEW.coll_obj_disposition
	      );
	END IF;

END;

ALTER TRIGGER "COLL_OBJECT_CT_CHECK" ENABLE