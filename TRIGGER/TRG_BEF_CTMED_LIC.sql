
  CREATE OR REPLACE TRIGGER "TRG_BEF_CTMED_LIC" 
BEFORE INSERT ON ctmedia_license
FOR EACH ROW
BEGIN
    IF :NEW.media_license_id IS NULL THEN
        SELECT sq_media_license_id.NEXTVAL
        INTO :NEW.media_license_id
        FROM DUAL;
    END IF;
END;

ALTER TRIGGER "TRG_BEF_CTMED_LIC" ENABLE