
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_LOAN_ITEM_PK" 
   before insert on MCZBASE.LOAN_ITEM
   for each row 
begin  
   if inserting then 
      if :NEW.LOAN_ITEM_ID is null then 
         select SEQ_LOAN_ITEM_ID.nextval into :NEW.LOAN_ITEM_ID from dual; 
      end if; 
   end if; 
end;



ALTER TRIGGER "TI_LOAN_ITEM_PK" ENABLE