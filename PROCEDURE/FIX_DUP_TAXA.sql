
  CREATE OR REPLACE PROCEDURE "FIX_DUP_TAXA" 
as

/*cursor c1 is
select taxon_name_id, full_taxon_name, display_name, source_authority
from taxonomy
where scientific_name in
(select scientific_name from taxonomy where family = 'Formicidae'
group by scientific_name 
having count(*) > 1);*/

cursor c1 is
select taxon_name_id, full_taxon_name, display_name, source_authority
from taxonomy
where full_taxon_name in
(select full_taxon_name from taxonomy where family = 'Formicidae'
group by full_taxon_name 
having count(*) > 1);

numTAXID taxonomy.taxon_name_id%TYPE;
numTAXID2 taxonomy.taxon_name_id%TYPE;
varFULLTAXNAME taxonomy.FULL_TAXON_NAME%TYPE;
varDISPLAY_NAME taxonomy.display_name%TYPE;
varSOURCE_AUTHORITY taxonomy.source_authority%TYPE;
numCOUNT number;
numTAXRECS number;
numNEWTAXID taxonomy.taxon_name_id%TYPE;

BEGIN

for c1_rec in c1 LOOP

numTAXID := c1_rec.taxon_name_id;
varFULLTAXNAME := c1_rec.full_taxon_name;
varDISPLAY_NAME := c1_rec.display_name;
varSOURCE_AUTHORITY := c1_rec.source_authority;
numTAXRECS :=0;
numCOUNT := 0;

   select count(*) into numTAXRECS from taxonomy where full_taxon_name = varFULLTAXNAME 
   and display_name = varDISPLAY_NAME and source_authority = varSOURCE_AUTHORITY;


if numTAXRECS > 1 then
  ---update tables
  select min(taxon_name_id) into numNEWTAXID 
    from taxonomy 
    where full_taxon_name = varFULLTAXNAME 
    and display_name = varDISPLAY_NAME
    and source_authority = varSOURCE_AUTHORITY;
  update identification_taxonomy 
    set taxon_name_id = numNEWTAXID 
    where taxon_name_id in 
    (select taxon_name_id 
      from taxonomy 
      where full_taxon_name = varFULLTAXNAME 
      and display_name = varDISPLAY_NAME
      and source_authority = varSOURCE_AUTHORITY)
    and taxon_name_id <> numNEWTAXID;
  update common_name 
    set taxon_name_id = numNEWTAXID 
    where taxon_name_id in 
    (select taxon_name_id 
      from taxonomy 
      where full_taxon_name = varFULLTAXNAME 
      and display_name = varDISPLAY_NAME
      and source_authority = varSOURCE_AUTHORITY)
    and taxon_name_id <> numNEWTAXID;
  update citation 
    set cited_taxon_name_id = numNEWTAXID 
    where cited_taxon_name_id in 
    (select taxon_name_id 
      from taxonomy 
      where full_taxon_name = varFULLTAXNAME 
      and display_name = varDISPLAY_NAME
      and source_authority = varSOURCE_AUTHORITY)
    and cited_taxon_name_id <> numNEWTAXID;
  ---delete dupes   
  delete common_name where taxon_name_id in
    (select taxon_name_id from taxonomy where full_taxon_name = varFULLTAXNAME and display_name = varDISPLAY_NAME and taxon_name_id <> numNEWTAXID and source_authority = varSOURCE_AUTHORITY);
  delete taxonomy where taxon_name_id in
     (select taxon_name_id from taxonomy where full_taxon_name = varFULLTAXNAME and display_name = varDISPLAY_NAME and taxon_name_id <> numNEWTAXID and source_authority = varSOURCE_AUTHORITY);
end if;

COMMIT;

END LOOP;
END;