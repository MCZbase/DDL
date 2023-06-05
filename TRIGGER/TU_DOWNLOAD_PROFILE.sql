
  CREATE OR REPLACE TRIGGER "TU_DOWNLOAD_PROFILE" 
   before update on "MCZBASE"."DOWNLOAD_PROFILE" 
   for each row 
begin  
   if updating then 
       select SYSTIMESTAMP into :NEW."MODIFIED" from dual; 
   end if; 
end;

ALTER TRIGGER "TU_DOWNLOAD_PROFILE" ENABLE