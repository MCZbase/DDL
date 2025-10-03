
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_CATITEM_AU_FLAT" 
AFTER UPDATE ON cataloged_item
FOR EACH ROW
BEGIN
UPDATE flat
SET stale_flag = 1,
lastuser=sys_context('USERENV', 'SESSION_USER'),
lastdate=SYSDATE
    WHERE collection_object_id = :OLD.collection_object_id
OR collection_object_id = :NEW.collection_object_id;
END;


ALTER TRIGGER "TR_CATITEM_AU_FLAT" ENABLE