
  CREATE OR REPLACE FUNCTION "CONCATSTRING" ( p_key_name in varchar2,
                       p_key_val  in varchar2,
                       p_other_col_name in varchar2,
                        p_tname     in varchar2 )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for 'select '||p_other_col_name||'
                         from '|| p_tname || '
                        where ' || p_key_name || ' = :x
                        order by '||p_other_col_name||''
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
 
 