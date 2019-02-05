
  CREATE OR REPLACE FUNCTION "TRANSPOSE" ( p_key_name in varchar2,
                       p_key_val  in varchar2,
                       p_other_col_name in varchar2,
                        p_tname     in varchar2 )
--  It is unclear what this function is for.
--  This function does not appear to be is used anywhere.
--
--  Given a table, a field name and value, and another field name, it returns
--  a dash delimited list of values of the other field name where the first field
--  name has the given value.
--  @param p_key_name the name of the field to query for p_key_val
--  @param p_key_val the value in where p_tname.p_key_name = p_key_val
--  @param p_other_col_name the field to select.
--  @param p_tname the name of the table to query
--  @return a dash separated list of values returned by the query
--      select p_other_col_name from p_tname where p_tname.p_key_name = p_key_val
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
                        where ' || p_key_name || ' = :x '
                   using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '-';
       end loop;
       close l_cur;

       return l_str;
  end;