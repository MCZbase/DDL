
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_SETTABLE" 
BEFORE INSERT OR UPDATE OF AUTO_TABLE,MEDIA_RELATIONSHIP ON MCZBASE.CTMEDIA_RELATIONSHIP 
FOR EACH ROW
BEGIN
  -- obtain the last word in media_relationship, set this as the value of auto_table.
  :NEW.auto_table := SUBSTR(:NEW.media_relationship,instr(:NEW.media_relationship,' ',-1)+1);
END;

ALTER TRIGGER "TRG_SETTABLE" ENABLE