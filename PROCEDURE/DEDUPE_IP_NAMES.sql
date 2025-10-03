
  CREATE OR REPLACE EDITIONABLE PROCEDURE "DEDUPE_IP_NAMES" as

/*cursor c1 is select scientific_name from taxonomy where taxon_name_id in
(select TAXON_NAME_ID from identification_taxonomy it, identification i, cataloged_item ci
    where it.identification_id = i.identification_id
    and i.collection_object_id = ci.collection_object_id 
    and ci.collection_cde = 'IP'
UNION
select cited_taxon_name_id from citation c, cataloged_item ci 
    where c.collection_object_id = ci.collection_object_id
    and ci.collection_cde = 'IP')
group by scientific_name
having count(*) > 1;*/

cursor c1 is 
select full_taxon_name from taxonomy where taxon_name_id in
(select TAXON_NAME_ID from identification_taxonomy it, identification i, cataloged_item ci
    where it.identification_id = i.identification_id
    and i.collection_object_id = ci.collection_object_id 
    and ci.collection_cde = 'IP'
UNION
select cited_taxon_name_id from citation c, cataloged_item ci 
    where c.collection_object_id = ci.collection_object_id
    and ci.collection_cde = 'IP')
group by full_taxon_name
having count(*) > 1;

cnt number;
newTaxonNameId number;
oldTaxonNameId number;
oldSA taxonomy.source_authority%TYPE;
newSA taxonomy.source_authority%TYPE;
oldAT taxonomy.author_text%TYPE;
newAT taxonomy.author_text%TYPE;

begin
for c1_rec in  c1 loop

select count(*) into cnt from taxonomy where full_taxon_name = c1_rec.full_taxon_name;

dbms_output.put_line(cnt ||  ' ' || c1_rec.full_taxon_name);

if cnt = 2 then
    /*select count(*) into cnt from taxonomy where scientific_name = c1_rec.scientific_name and phylorder is not null and family is not null;*/
    select count(*) into cnt from taxonomy where full_taxon_name = c1_rec.full_taxon_name and author_text is not null;
    
    if cnt = 1 then 
        select taxon_name_id into newTaxonNameId from taxonomy where full_taxon_name = c1_rec.full_taxon_name and author_text is not null;
        select taxon_name_id into oldTaxonNameId from taxonomy where full_taxon_name = c1_rec.full_taxon_name and taxon_name_id <> newTaxonNameId;
        
        update identification_taxonomy set taxon_name_id = newTaxonNameId where taxon_name_id = oldTaxonNameId;
        update citation set cited_taxon_name_id = newTaxonNameId where cited_taxon_name_id = oldTaxonNameId;
        select count(*) into cnt from taxonomy_publication where taxon_name_id in (oldTaxonNameId, newTaxonNameId);
        if cnt > 0 then
            delete taxonomy_publication where taxon_name_id in (oldTaxonNameId, newTaxonNameId);
            insert into taxonomy_publication(taxon_name_id, publication_id)
            select distinct cited_taxon_name_id, publication_id from citation where cited_taxon_name_id = newTaxonNameId;
        end if;
        
        select source_authority into newSA from taxonomy where taxon_name_id = newTaxonNameId;
        select source_authority into oldSA from taxonomy where taxon_name_id = oldTaxonNameId;
        
        If newSA = 'WoRMS (World Register of Marine Species)' or oldSA = 'WoRMS (World Register of Marine Species)' then 
            update taxonomy set source_authority = 'X_WoRMS (World Register of Marine Species)' where taxon_name_id = newTaxonNameId;
        else 
            update taxonomy set source_authority = 'X_MCZ' where taxon_name_id = newTaxonNameId;
        end if;
        
        delete taxonomy where taxon_name_id = oldTaxonNameId;
    ELSIF cnt = 0 then
        select min(taxon_name_id) into newTaxonNameId from taxonomy where full_taxon_name = c1_rec.full_taxon_name;
        select taxon_name_id into oldTaxonNameId from taxonomy where full_taxon_name = c1_rec.full_taxon_name and taxon_name_id <> newTaxonNameId;
        
        update identification_taxonomy set taxon_name_id = newTaxonNameId where taxon_name_id = oldTaxonNameId;
        update citation set cited_taxon_name_id = newTaxonNameId where cited_taxon_name_id = oldTaxonNameId;
        select count(*) into cnt from taxonomy_publication where taxon_name_id in (oldTaxonNameId, newTaxonNameId);
        if cnt > 0 then
            delete taxonomy_publication where taxon_name_id in (oldTaxonNameId, newTaxonNameId);
            insert into taxonomy_publication(taxon_name_id, publication_id)
            select distinct cited_taxon_name_id, publication_id from citation where cited_taxon_name_id = newTaxonNameId;
        end if;
        
        select source_authority into newSA from taxonomy where taxon_name_id = newTaxonNameId;
        select source_authority into oldSA from taxonomy where taxon_name_id = oldTaxonNameId;
        
        If newSA = 'WoRMS (World Register of Marine Species)' or oldSA = 'WoRMS (World Register of Marine Species)' then 
            update taxonomy set source_authority = 'X_WoRMS (World Register of Marine Species)' where taxon_name_id = newTaxonNameId;
        else 
            update taxonomy set source_authority = 'X_MCZ' where taxon_name_id = newTaxonNameId;
        end if;
        
        delete taxonomy where taxon_name_id = oldTaxonNameId;
    elsif cnt = 2 then
        select min(taxon_name_id) into newTaxonNameId from taxonomy where full_taxon_name = c1_rec.full_taxon_name;
        select taxon_name_id into oldTaxonNameId from taxonomy where full_taxon_name = c1_rec.full_taxon_name and taxon_name_id <> newTaxonNameId;
        
        select author_text into oldAT from taxonomy where taxon_name_id  = oldTaxonNameId;
        select author_text into newAT from taxonomy where taxon_name_id  = newTaxonNameId;
        
        if oldAT = newAT then
            update identification_taxonomy set taxon_name_id = newTaxonNameId where taxon_name_id = oldTaxonNameId;
            update citation set cited_taxon_name_id = newTaxonNameId where cited_taxon_name_id = oldTaxonNameId;
            select count(*) into cnt from taxonomy_publication where taxon_name_id in (oldTaxonNameId, newTaxonNameId);
            if cnt > 0 then
                delete taxonomy_publication where taxon_name_id in (oldTaxonNameId, newTaxonNameId);
                insert into taxonomy_publication(taxon_name_id, publication_id)
                select distinct cited_taxon_name_id, publication_id from citation where cited_taxon_name_id = newTaxonNameId;
            end if;
            
            select source_authority into newSA from taxonomy where taxon_name_id = newTaxonNameId;
            select source_authority into oldSA from taxonomy where taxon_name_id = oldTaxonNameId;
            
            If newSA = 'WoRMS (World Register of Marine Species)' or oldSA = 'WoRMS (World Register of Marine Species)' then 
                update taxonomy set source_authority = 'X_WoRMS (World Register of Marine Species)' where taxon_name_id = newTaxonNameId;
            else 
                update taxonomy set source_authority = 'X_MCZ' where taxon_name_id = newTaxonNameId;
            end if;
            
            delete taxonomy where taxon_name_id = oldTaxonNameId;    
        end if;
    end if;
end if;
commit;
end loop;
end;