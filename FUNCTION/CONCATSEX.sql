
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATSEX" (p_key_val  in varchar2 )
return varchar2
-- return a comma separated list of values of the sex attribute for a collection object.
-- @param p_key_val the collection_object_id for which to return values of the sex attribute.
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for 'select attribute_value
                         from attributes
                        where
                        attribute_type=''sex'' and
                        collection_object_id = :x'
                   using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := ', ';
       end loop;
       close l_cur;

       return l_str;
  end;