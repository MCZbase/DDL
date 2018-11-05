
  CREATE OR REPLACE TRIGGER "TR_LOCALITY_VPD_AID" 
AFTER INSERT OR DELETE ON locality
FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO vpd_collection_locality (locality_id,collection_id,stale_fg)
        VALUES (:NEW.locality_id,0,0);
    ELSIF deleting THEN
        DELETE FROM vpd_collection_locality WHERE locality_id=:OLD.locality_id;
    END IF;
END;

ALTER TRIGGER "TR_LOCALITY_VPD_AID" ENABLE