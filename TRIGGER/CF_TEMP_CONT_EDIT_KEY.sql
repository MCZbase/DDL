
  CREATE OR REPLACE TRIGGER "CF_TEMP_CONT_EDIT_KEY" 
 before insert  ON cf_temp_cont_edit
 for each row
    begin
    if :NEW.key is null then
    select somerandomsequence.nextval into :new.key from dual;
    end if;
    end;

ALTER TRIGGER "CF_TEMP_CONT_EDIT_KEY" ENABLE