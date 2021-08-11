
  CREATE OR REPLACE FUNCTION "AUTHYEAR" (p_key_val  in varchar2 )
    return varchar2
    -- @deprecated  does not appear to be used anywhere, name and query differ, returns part/preserve method, not author/year.
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

       open l_cur for 'select  decode(part_modifier,
       									null,'''',
       									part_modifier || '' '' ) || part_name
                                || decode(preserve_method,
                                null,'''',
                                '' (''||preserve_method||'')'')
                         from specimen_part
                        where derived_from_cat_item = :x
                        ORDER BY part_name
'
                                           using p_key_val
                   ;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
  end;
  -- call with