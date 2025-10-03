
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_CATITEM_VPD_AD" 
AFTER DELETE ON cataloged_item
FOR EACH ROW
DECLARE lid collecting_event.locality_id%TYPE;
BEGIN
    SELECT locality_id INTO lid
    FROM collecting_event
    WHERE collecting_event_id = :OLD.collecting_event_id;

    UPDATE  vpd_collection_locality
    SET stale_fg = 1
    WHERE locality_id=lid
    AND collection_id=:OLD.collection_id;
END;


ALTER TRIGGER "TR_CATITEM_VPD_AD" ENABLE