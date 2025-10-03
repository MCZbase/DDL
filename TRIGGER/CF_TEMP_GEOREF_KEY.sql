
  CREATE OR REPLACE EDITIONABLE TRIGGER "CF_TEMP_GEOREF_KEY" 
 before insert  ON "MCZBASE"."CF_TEMP_GEOREF"
 for each row
    begin
    if :NEW.key is null then
    select somerandomsequence.nextval into :new.key from dual;
    end if;
    end;



ALTER TRIGGER "CF_TEMP_GEOREF_KEY" ENABLE