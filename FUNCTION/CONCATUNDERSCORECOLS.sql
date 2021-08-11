
  CREATE OR REPLACE FUNCTION "CONCATUNDERSCORECOLS" (collection_object_id  in varchar2)
return varchar2
    -- given a  collection_object_id return a concatenated list of named group 
    -- memberships for the specified cataloged item
    -- @param collection_object_id the collection object id to look up
    -- @return a comma separated list of named groups for the specified 
    --  collection object.
as
   type rc is ref cursor;
   l_str    varchar2(4000);
   l_sep    varchar2(30);
   l_val    varchar2(4000);
   l_cur    rc;
begin
     l_sep := '';
      open l_cur for '
        select collection_name 
        from underscore_relation
           left join underscore_collection on underscore_relation.underscore_collection_id = underscore_collection.underscore_collection_id
        where
           collection_object_id = :x
      '
      using collection_object_id;

      loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
       end loop;
    close l_cur;

    return l_str;
end;