
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_COLLOBJECT_AIU_FLAT" 
AFTER INSERT OR UPDATE ON coll_object
FOR EACH ROW
DECLARE
    cid NUMBER;
    cnt number;
BEGIN
---FOR i IN 1 .. state_pkg.newRows.count LOOP
IF :NEW.coll_object_type = 'CI' then
    UPDATE flat
    SET stale_flag = 1,
        lastuser=sys_context('USERENV', 'SESSION_USER'),
        lastdate=SYSDATE
            WHERE collection_object_id = :NEW.collection_object_id;
---END LOOP;
elsif :NEW.coll_object_type = 'SP' then 
    select count(*) into cnt from specimen_part where collection_object_id = :NEW.collection_object_id;
    if cnt = 1 then
        select derived_from_cat_item into CID 
            from specimen_part 
            where collection_object_id = :NEW.collection_object_id;
        UPDATE flat
        SET stale_flag = 1,
            lastuser=sys_context('USERENV', 'SESSION_USER'),
            lastdate=SYSDATE
                WHERE collection_object_id = CID;
    end if;
END IF;
END;

ALTER TRIGGER "TR_COLLOBJECT_AIU_FLAT" ENABLE