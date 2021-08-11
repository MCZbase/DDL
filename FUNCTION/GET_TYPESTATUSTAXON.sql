
  CREATE OR REPLACE FUNCTION "GET_TYPESTATUSTAXON" (collection_object_id in NUMBER, typestatus in VARCHAR2 )
return number
--  Given a collection object id and a type status, return the taxon_name_id for the first scientific name with that
--  type status in the identification history of the collection object.
--  @param collection_object_id the cataloged item for which to obtain the taxon_name_id
--  @param typestatus the type status 
--  @see get_typestatusname to obtain a matching name, assuminng a single type of this status
--    if there is more than one type name of this rank, get_typestatusauthor and get_typestatus name
--    used in a single query may not return the name and author for the same taxon record.
--  @see get_typestatusauthor to obtain a matching name, assuminng a single type of this status
--    if there is more than one type name of this rank, get_typestatusauthor and get_typestatus name
--    used in a single query may not return the name and author for the same taxon record.
as
   type rc is ref cursor;
   retval number;
   l_val number;
   l_cur rc;

begin
   open l_cur for '
      select distinct taxon_name_id 
      from citation left join taxonomy on cited_taxon_name_id = taxon_name_id 
      where citation.collection_object_id  = :x and type_status = :x and rownum < 2 
      '
   using collection_object_id, typestatus;
   loop
      fetch l_cur into l_val;
      exit when l_cur%notfound;
      retval :=  l_val;
   end loop;
   close l_cur;

   return retval;

end;