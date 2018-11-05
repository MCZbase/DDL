
  CREATE OR REPLACE TRIGGER "TR_SPECIMENPART_AD" 
AFTER DELETE ON SPECIMEN_PART
FOR EACH ROW
DECLARE
BEGIN
    DELETE FROM coll_object_remark
    WHERE collection_object_id = :OLD.collection_object_id;
    DELETE FROM coll_object
    WHERE collection_object_id = :OLD.collection_object_id;
END;
ALTER TRIGGER "TR_SPECIMENPART_AD" ENABLE