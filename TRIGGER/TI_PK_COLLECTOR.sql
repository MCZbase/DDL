
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_PK_COLLECTOR" 
before insert on MCZBASE.COLLECTOR
for each row 
begin  
  if inserting then
      if :NEW.COLLECTOR_ID is null then 
         select SEQ_COLLECTOR_ID.nextval into :NEW.COLLECTOR_ID from dual; 
      end if; 
   end if; 
end;

ALTER TRIGGER "TI_PK_COLLECTOR" ENABLE