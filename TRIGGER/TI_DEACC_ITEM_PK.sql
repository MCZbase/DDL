
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_DEACC_ITEM_PK" 
   before insert on MCZBASE.DEACC_ITEM
   for each row 
begin  
   if inserting then 
      if :NEW.DEACC_ITEM_ID is null then 
         select SEQ_DEACC_ITEM_ID.nextval into :NEW.DEACC_ITEM_ID from dual; 
      end if; 
   end if; 
end;
ALTER TRIGGER "TI_DEACC_ITEM_PK" ENABLE