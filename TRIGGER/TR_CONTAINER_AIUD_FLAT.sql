
  CREATE OR REPLACE TRIGGER "TR_CONTAINER_AIUD_FLAT" 
AFTER UPDATE OR DELETE ON container
FOR EACH ROW
DECLARE id NUMBER;
BEGIN
    IF :NEW.container_type = 'collection object' then
        select sp.derived_from_cat_item into ID from 
           specimen_part sp, coll_obj_cont_hist ch
            where sp.collection_object_id = ch.collection_object_id
            and ch.container_id = :NEW.container_id
            and ch.current_container_fg = 1;
    end if;

    UPDATE flat
SET stale_flag = 1,
lastuser=sys_context('USERENV', 'SESSION_USER'),
lastdate=SYSDATE
WHERE collection_object_id = id;
END;
ALTER TRIGGER "TR_CONTAINER_AIUD_FLAT" ENABLE