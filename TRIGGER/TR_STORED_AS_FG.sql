
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_STORED_AS_FG" 
AFTER INSERT OR UPDATE ON IDENTIFICATION
FOR EACH ROW
DECLARE 
    numrows NUMBER;
    acceptedID number;
    pragma autonomous_transaction;

BEGIN
    SELECT count(*) INTO numrows
    FROM identification
    WHERE collection_object_id = :new.collection_object_id
    AND STORED_AS_FG = 1
    and identification_id <> :new.identification_id;
	
    IF numrows > 0 AND :new.STORED_AS_FG = 1 THEN
    raise_application_error(
        -20001,
        'Only one identification can be marked as "stored as."');
    END IF;
    if inserting then 
        acceptedID := :new.ACCEPTED_ID_FG;
    else
       SELECT ACCEPTED_ID_FG into acceptedID from identification where identification_id = :new.identification_id;
    end if;   
    
    IF acceptedID = 1 and :new.STORED_AS_FG = 1 then 
    raise_application_error(
        -20001,
        'The Current Identification can not be marked as "stored as."');
    END IF;
      
END;
ALTER TRIGGER "TR_STORED_AS_FG" ENABLE