
  CREATE OR REPLACE FUNCTION "CONCATFLATVALUESBYID" (idfield in varchar2, fieldval in varchar2, fieldtoconcat in varchar2, collcode in varchar2)
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin
    If collcode is null then 
      open l_cur for 'select distinct ' || fieldtoconcat || ' 
                         from flat
                        where ' ||                      
                        idfield || '= :x'
                   using fieldval;
    Else
      open l_cur for 'select distinct ' || fieldtoconcat || ' 
                         from flat
                        where ' ||                      
                        idfield || '= :x
                        and collection_cde = :y'
                   using fieldval, collcode;
    End IF;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := ', ';
       end loop;
       close l_cur;

       return l_str;
  end;