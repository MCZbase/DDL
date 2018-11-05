
  CREATE OR REPLACE FUNCTION "CONCATCOMMONNAME" (p_key_val  in varchar2 )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(3);
       l_val    varchar2(4000);
   	l_cur    rc;
   begin
    open l_cur for 'select decode(common_name,
    						null,''None recorded.'',
    						common_name) common_name
                         from common_name
                        where taxon_name_id = :x
                        ORDER BY common_name'
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
 
 