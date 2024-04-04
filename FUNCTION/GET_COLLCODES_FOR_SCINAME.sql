
  CREATE OR REPLACE FUNCTION "GET_COLLCODES_FOR_SCINAME" ( sciname in varchar2 )
return VARCHAR
-- Function to obtain list of collection codes and cataloged item counts for a scientific name.
-- @param sciname is the scientific_name to lookup
-- @return a string list of collection codes and cataloged item counts of material
--    from the specified collecting event.
as 
   type rc is ref cursor;
   retval varchar(2000);
   ccode varchar(50);
   cnt varchar(500);
   sep varchar(2);
   cur rc;
begin
   retval := '';
   sep := '';
   open cur for '
      select listagg(collection_cde, '','') within group (order by collection_cde) from
(select distinct collection_cde from 
(select collection_cde, ci.collection_object_id, ''ID'' as type
from identification_taxonomy it
join identification i on it.identification_id=i.identification_id
join cataloged_item ci on i.collection_object_id = ci.collection_object_id
join taxonomy t on t.taxon_name_id = it.taxon_name_id
where t.scientific_name = :x
union 
select collection_cde, ci.collection_object_id, ''CITATION'' 
from citation c
join cataloged_item ci on c.collection_object_id = ci.collection_object_id
join taxonomy t on c.cited_taxon_name_id = t.taxon_name_id
where scientific_name = :x)
group by collection_Cde, type)' using sciname,sciname;
   
   loop
      fetch cur into cnt;
      exit when cur%notfound;
      retval := retval || sep || cnt;
      sep := ', ';
   end loop;   
   close cur;   
   return retval;
end;