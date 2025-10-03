
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_DOWNLOAD_PROFILE_ID" 
   before insert on "MCZBASE"."DOWNLOAD_PROFILE" 
   for each row 
begin  
   if inserting then 
      if :NEW."DOWNLOAD_PROFILE_ID" is null then 
         select SQ_DOWNLOAD_PROFILE_ID.nextval into :NEW."DOWNLOAD_PROFILE_ID" from dual; 
      end if; 
   end if; 
end;


ALTER TRIGGER "TRG_DOWNLOAD_PROFILE_ID" ENABLE