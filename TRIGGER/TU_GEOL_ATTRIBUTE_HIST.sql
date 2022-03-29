
  CREATE OR REPLACE TRIGGER "TU_GEOL_ATTRIBUTE_HIST" 
BEFORE UPDATE OF GEO_ATT_VALUE ON MCZBASE.GEOLOGY_ATTRIBUTES  FOR EACH ROW
-- preserve history of values (supporting attribute value merges)
BEGIN
  IF :old.previous_values is null THEN
     :new.previous_values := :old.geo_att_value;
  ELSE 
     :new.previous_values := :old.previous_values || '|' || :old.geo_att_value;
  END IF;
END;
ALTER TRIGGER "TU_GEOL_ATTRIBUTE_HIST" ENABLE