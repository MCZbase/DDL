
  CREATE OR REPLACE EDITIONABLE TRIGGER "COLL_OBJECT_DEACC_CHECK" 
before UPDATE or INSERT ON coll_object
for each row
declare
numrows number;
BEGIN
    If :new.coll_object_type in ('SP', 'SS') and :new.coll_obj_disposition like 'deaccessioned%' then 
        SELECT COUNT(*) INTO numrows FROM DEACC_ITEM WHERE collection_object_id = :new.collection_object_id;
        IF (numrows = 0) THEN
             raise_application_error(
                -20001,
                'You cannot change the disposition to deaccessioned before adding item to a deaccession'
              );
        END IF;
    END IF;
END;

ALTER TRIGGER "COLL_OBJECT_DEACC_CHECK" ENABLE