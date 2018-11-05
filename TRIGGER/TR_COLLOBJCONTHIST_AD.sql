
  CREATE OR REPLACE TRIGGER "TR_COLLOBJCONTHIST_AD" 
AFTER DELETE ON coll_obj_cont_hist
FOR EACH ROW
BEGIN
    DELETE FROM container WHERE container_id = :OLD.container_id;
END;

ALTER TRIGGER "TR_COLLOBJCONTHIST_AD" ENABLE