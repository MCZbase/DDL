
  CREATE OR REPLACE TRIGGER "TR_MEDIA_IU_AUTO" 
BEFORE INSERT OR UPDATE OF MEDIA_URI ON MCZBASE.MEDIA 
-- parse, if possible, the provided media_uri into component parts for search
FOR EACH ROW
BEGIN
   :NEW.AUTO_EXTENSION := substr(regexp_substr(:NEW.MEDIA_URI,'\.[^0-9]{2,4}[0-9]{0,1}$'),2);
   :NEW.AUTO_FILENAME := replace(regexp_substr(:NEW.MEDIA_URI,'/[^/]+$'),'/','');
   :NEW.AUTO_PATH := regexp_substr(replace(regexp_substr(:NEW.MEDIA_URI,'://.+/'),'://',''),'/.*');
   :NEW.AUTO_HOST := replace(replace(regexp_substr(:NEW.MEDIA_URI,'://[^/]+/'),'://',''),'/','');
   :NEW.AUTO_PROTOCOL := replace(regexp_substr(:NEW.MEDIA_URI,'^[htpsflHTPSFL]{3,5}://'),'://','');
END;
ALTER TRIGGER "TR_MEDIA_IU_AUTO" ENABLE