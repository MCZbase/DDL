
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_COLLECTION_SYNC_BUID" 
BEFORE UPDATE OR INSERT OR DELETE ON collection  
FOR EACH ROW
BEGIN
    IF inserting THEN
        INSERT INTO cf_collection (
            cf_collection_id,
            collection_id,
            dbusername,
            dbpwd,
            portal_name,
            collection)
        VALUES (
            :NEW.collection_id,
            :NEW.collection_id,
            'PUB_USR_' || upper(:NEW.institution_acronym) || '_' || upper(:NEW.collection_cde),
            'userpw.' || :NEW.collection_id,
            upper(:NEW.institution_acronym) || '_' || upper(:NEW.collection_cde),
            :NEW.collection);
    ELSIF deleting THEN
        DELETE FROM cf_collection WHERE collection_id = :OLD.collection_id;
    ELSIF updating THEN
        IF (:NEW.collection_id != :OLD.collection_id) THEN
            UPDATE cf_collection SET
                collection_id = :NEW.collection_id,
                cf_collection_id = :NEW.collection_id,
                dbusername = 'PUB_USR_' || upper(:NEW.institution_acronym) || '_' || upper(:NEW.collection_cde),
	            dbpwd = 'userpw.' || :NEW.collection_id,
	            portal_name = upper(:NEW.institution_acronym) || '_' || upper(:NEW.collection_cde),
	            collection = :NEW.collection
            WHERE collection_id=:OLD.collection_id;
        END IF;
    END IF;
END;


ALTER TRIGGER "TR_COLLECTION_SYNC_BUID" ENABLE