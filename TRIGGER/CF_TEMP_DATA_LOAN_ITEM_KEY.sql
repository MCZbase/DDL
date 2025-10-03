
  CREATE OR REPLACE EDITIONABLE TRIGGER "CF_TEMP_DATA_LOAN_ITEM_KEY" 
 before insert  ON cf_temp_data_loan_item
 for each row
    begin
        if :NEW.key is null then
            select somerandomsequence.nextval into :new.key from dual;
        end if;
    end;


ALTER TRIGGER "CF_TEMP_DATA_LOAN_ITEM_KEY" ENABLE