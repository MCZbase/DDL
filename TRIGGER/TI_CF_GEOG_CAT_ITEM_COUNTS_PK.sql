
  CREATE OR REPLACE TRIGGER "TI_CF_GEOG_CAT_ITEM_COUNTS_PK" 
   before insert on MCZBASE.cf_geog_cat_item_counts
   for each row 
begin  
   if inserting then 
      if :NEW.KEY is null then 
         select SEQ_cf_geog_cat_item_counts.nextval into :NEW.KEY from dual; 
      end if; 
   end if; 
end;

ALTER TRIGGER "TI_CF_GEOG_CAT_ITEM_COUNTS_PK" ENABLE