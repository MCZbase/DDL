
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_MEDIA_KEYWORDS_I_PK" 
   before insert on "MCZBASE"."MEDIA_KEYWORDS" 
   for each row 
begin  
   if inserting then 
      if :NEW."MEDIA_KEYWORDS_ID" is null then 
         select MCZBASE.seq_media_keyword_id.nextval into :NEW."MEDIA_KEYWORDS_ID" from dual; 
      end if; 
   end if; 
end;

ALTER TRIGGER "TRG_MEDIA_KEYWORDS_I_PK" ENABLE