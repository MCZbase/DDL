
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_CF_PUB_TYPE_ATTRIBITE_PK" 
   before insert on MCZBASE.CF_PUB_TYPE_ATTRIBUTE 
   for each row 
begin  
   if inserting then 
      if :NEW."CF_PUB_TYPE_ATTRIBUTE_ID" is null then 
         select SEQ_CF_PUB_TYPE_ATTRIBUTE_PK.nextval into :NEW.CF_PUB_TYPE_ATTRIBUTE_ID from dual; 
      end if; 
   end if; 
end;


ALTER TRIGGER "TI_CF_PUB_TYPE_ATTRIBITE_PK" ENABLE