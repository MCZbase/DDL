
  CREATE OR REPLACE EDITIONABLE TRIGGER "COLL_OBJ_DATA_CHECK" BEFORE INSERT OR UPDATE ON COLL_OBJ_OTHER_ID_NUM FOR EACH ROW
BEGIN
    if :new.other_id_type = 'AF' then
        IF :NEW.OTHER_ID_PREFIX IS NOT NULL OR :NEW.OTHER_ID_SUFFIX IS NOT NULL THEN
            raise_application_error(-20000,'AF must be numeric!');
        end if;
    end if;
    if :new.other_id_type = 'NK' then
        IF :NEW.OTHER_ID_PREFIX IS NOT NULL OR :NEW.OTHER_ID_SUFFIX IS NOT NULL THEN
            raise_application_error(-20000,'NK must be numeric!');
        end if;
    end if;
END;


ALTER TRIGGER "COLL_OBJ_DATA_CHECK" ENABLE