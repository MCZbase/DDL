
  CREATE OR REPLACE FUNCTION "CONCATATTRIBUTESJSON" ( p_key_val  in varchar2)
    return varchar2
    as
-- assemble the set of attributes, including underscore_collection membership for a
-- collection object as a json data structure.
-- @param p_key_val the collection_object_id for which to look up the attributes.
-- @return json string with attributes and underscore_collection membership as key value pairs.
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for '
          select 
            ''"'' || attribute_type
            || ''":"'' ||
            decode(attribute_value,
                null,'''',
                attribute_value) ||
            decode(attribute_units,
                null,'''',
            attribute_units) 
            || ''"''
        from attributes
        where collection_object_id = :x
    union
        select 
            ''"part of group":"'' || collection_name || ''"''
        from underscore_relation 
            left outer join underscore_collection on underscore_relation.underscore_collection_id = underscore_collection.underscore_collection_id
        where collection_object_id = :y
        and collection_name is not null
        '
        using p_key_val, p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := ', ';
       end loop;
       close l_cur;

       l_str := '{' || l_str || '}';
       return l_str;
  end;