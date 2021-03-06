
  CREATE OR REPLACE FUNCTION "CONCATFAMILYBYLOCID" (p_key_val  in varchar2, collcode in varchar2 )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for 'select distinct family
                         from flat
                        where
                        locality_id = :x
                        and collection_cde = :y'
                   using p_key_val, collcode;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := ', ';
       end loop;
       close l_cur;

       return l_str;
  end;