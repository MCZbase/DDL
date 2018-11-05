
  CREATE OR REPLACE FUNCTION "GET_TYPESTATUSNAME" (collection_object_id in NUMBER, typestatus in VARCHAR2 )
return varchar2
--  Given a collection object id and a type status, return the first scientific name with that
--  type status in the identification history of the collection object, in its display form.
as
   type rc is ref cursor;
   l_str varchar2(4000);
   l_val varchar2(4000);
   l_cur rc;
   
begin
   l_str := '';
   open l_cur for '
      select distinct display_name 
      from citation left join taxonomy on cited_taxon_name_id = taxon_name_id 
      where citation.collection_object_id  = :x and type_status = :x and rownum < 2 '
   using collection_object_id, typestatus;
   loop
      fetch l_cur into l_val;
      exit when l_cur%notfound;
      l_str :=  l_val;
   end loop;
   close l_cur;
   
   return l_str;

end;