
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TYPESTATUSAUTHOR" (collection_object_id in NUMBER, typestatus in VARCHAR2 )
return varchar2
--  Given a collection object id and a type status, return the author for the first scientific name with that
--  type status in the identification history of the collection object, in its display form.
--  @param collection_object_id the cataloged item for which to obtain the type auuthor
--  @param typestatus the type status 
--  @see get_typestatusname to obtain a matching name, assuminng a single type of this status
--    if there is more than one type name of this rank, get_typestatusauthor and get_typestatus name
--    used in a single query may not return the name and author for the same taxon record.
as
   type rc is ref cursor;
   l_str varchar2(4000);
   l_val varchar2(4000);
   l_cur rc;

begin
   l_str := '';
   open l_cur for '
      select distinct author_text 
      from citation left join taxonomy on cited_taxon_name_id = taxon_name_id 
      where citation.collection_object_id  = :x and type_status = :x and rownum < 2 
      '
   using collection_object_id, typestatus;
   loop
      fetch l_cur into l_val;
      exit when l_cur%notfound;
      l_str :=  l_val;
   end loop;
   close l_cur;

   return l_str;

end;