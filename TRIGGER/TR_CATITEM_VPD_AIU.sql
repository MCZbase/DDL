
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_CATITEM_VPD_AIU" 
AFTER INSERT OR UPDATE ON cataloged_item
FOR EACH ROW
DECLARE lid collecting_event.locality_id%TYPE;
BEGIN
    SELECT locality_id INTO lid
    FROM collecting_event
    WHERE collecting_event_id = :NEW.collecting_event_id;

    INSERT INTO vpd_collection_locality (collection_id, locality_id, STALE_FG)
    VALUES(:NEW.collection_id, lid,0);
EXCEPTION WHEN dup_val_on_index THEN
    NULL;
END;

ALTER TRIGGER "TR_CATITEM_VPD_AIU" ENABLE