
  CREATE OR REPLACE PROCEDURE "FIX_IP_NAMES" as

cursor c1 is select * from X_FIXIPNAMES where CORRECTED_SCIENTIFIC_NAME is not null and processed is null;

newGenus mczbase.taxonomy.genus%type;
newSpecies mczbase.taxonomy.species%type;
newNC mczbase.taxonomy.nomenclatural_code%type;
oldTAXID number;
newTAXID number;
newSciName mczbase.identification.scientific_name%type;
ERR_NUM NUMBER(5); 
err_msg VARCHAR2(513); 
numID number;
cnt number;

begin
NULL;
/*
for c1_rec in c1 loop
begin
newGenus :=null;
newSpecies :=null;
newNC :=null;
oldTAXID :=null;
newTAXID :=null;
newSciName :=null;

numID := c1_rec.id;

select count(*) into cnt from taxonomy where scientific_name = c1_rec.corrected_scientific_name;

if cnt=0 then
  ---update X_FIXIPNAMES set error = 'no taxon name found' where id = c1_rec.id;
  
  select min(taxon_name_id) into oldTAXID from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name));
  
  if oldTAXID is not null then 
  
    if regexp_like(trim(c1_rec.corrected_scientific_name), ' ') then 
      newGenus := regexp_substr(trim(c1_rec.corrected_scientific_name), '^[^ ]*');
      newSpecies := regexp_substr(trim(c1_rec.corrected_scientific_name), '[^ ]*$');
    else
      newGenus := regexp_substr(trim(c1_rec.corrected_scientific_name), '^[^ ]*');
      newSpecies := null;
    end if;
    
    if regexp_like(trim(c1_rec.corrected_scientific_name), '[^A-Za-z ]') then 
      newNC := 'noncompliant'; 
    else  
      newNC := 'ICZN';
    end if;  
    
    ---back up ids for reference
    insert into x_fixedipids
    (select * from identification where identification_id in 
      (select identification_id from identification_taxonomy where taxon_name_id in 
      (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name)))));
    
    update taxonomy set genus = newGenus, species = newSpecies, nomenclatural_code = newNC, source_authority = 'MCZ' 
      where taxon_name_id in 
        (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name)));
    
    select scientific_name into newSciName from taxonomy where taxon_name_id = oldTAXID;
    
    update identification 
      set scientific_name = newSciName || decode(trim(c1_rec.taxon_b_identifier), null, '', ' ' || trim(c1_rec.taxon_b_identifier)), 
      taxa_formula = 'A' || decode(trim(c1_rec.taxon_b_identifier), null, '', ' ' || trim(c1_rec.taxon_b_identifier)) 
      where identification_id in 
        (select identification_id from identification_taxonomy where taxon_name_id in 
          (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name))));
    
    update X_FIXIPNAMES set processed = 'Y', error = 'Reused taxonomy record: ' || oldTAXID || '; new sciname = ' || newSciName 
      where id = numID;
  else
     update X_FIXIPNAMES set processed = 'Y', error = 'Bad taxonomy no longer exists'
      where id = numID;
  END IF;
elsif cnt > 1 then
  update X_FIXIPNAMES set error = 'multiple taxon names found' where id = c1_rec.id;

else
  select min(taxon_name_id) into oldTAXID from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name));
  
  if oldTAXID is not null then
    select taxon_name_id, scientific_name into newTAXID, newSciName 
      from taxonomy 
      where lower(trim(scientific_name)) = lower(trim(c1_rec.corrected_scientific_name));
    
    insert into x_fixedipids
    (select * from identification where identification_id in 
      (select identification_id from identification_taxonomy where taxon_name_id in 
      (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name)))));
    
    update identification 
      set taxa_formula =  'A' || decode(trim(c1_rec.taxon_b_identifier), null, '', ' ' || trim(c1_rec.taxon_b_identifier)), 
      scientific_name = newSciName || decode(trim(c1_rec.taxon_b_identifier), null, '', ' ' || trim(c1_rec.taxon_b_identifier))
      where identification_id in 
        (select identification_id from identification_taxonomy where taxon_name_id in 
          (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name))));
      
    update identification_taxonomy set taxon_name_id = newTAXID 
      where taxon_name_id in (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name)));
      
      
    update citation set cited_taxon_name_id = newTAXID where cited_taxon_name_id in 
      (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name)));
    
    update taxonomy_publication set taxon_name_id = newTAXID where taxon_name_id in 
      (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name)));
      
    delete taxonomy where taxon_name_id in 
      (select taxon_name_id from taxonomy where lower(trim(scientific_name)) = lower(trim(c1_rec.scientific_name)));
  
    update X_FIXIPNAMES set processed = 'Y', error = 'New tax ID: ' || newTAXID || '; new sciname = ' || newSciName 
      where id = c1_rec.id; 
  ELSE
     update X_FIXIPNAMES set processed = 'Y', error = 'Bad taxonomy no longer exists'
      where id = numID;
  END IF;    

end if;

      EXCEPTION
  
       WHEN OTHERS THEN
       ROLLBACK;
       err_num := SQLCODE;
       err_msg := SUBSTR(SQLERRM, 1, 512);
       UPDATE X_FIXIPNAMES SET error = err_num || ': ' || err_msg WHERE ID=numID;
       COMMIT;
    end;
  null;
  commit;
end loop;
*/
end;