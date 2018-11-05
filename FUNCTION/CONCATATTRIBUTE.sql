
  CREATE OR REPLACE FUNCTION "CONCATATTRIBUTE" ( p_key_val  in varchar2)
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for 'select attribute_type
      						|| '': '' ||
      						decode(attribute_value,
      							null,'''',
      							attribute_value) ||
      						decode(attribute_units,
      							null,'''',
      							attribute_units)
                         from attributes
                        where collection_object_id = :x
                        order by attribute_type, attribute_value'
                   using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
  end;
 
 