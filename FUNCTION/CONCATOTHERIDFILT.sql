
  CREATE OR REPLACE FUNCTION "CONCATOTHERIDFILT" (p_key_val  in varchar2,noFieldNum in number DEFAULT 0)
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(2);
       l_val    varchar2(4000);
   		l_cur    rc;
   begin

       open l_cur for 'select other_id_type || ''=''||other_id_num
                         from coll_obj_other_id_num
                        where collection_object_id = :x
                        order by other_id_type, other_id_num'
                   using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           if l_val LIKE '%Field Num%' then
	           if noFieldNum = 1 then
	           		l_str := l_str || l_sep || 'Field Num=Masked';
	           	    l_sep := '; ';
	           else
	           		l_str := l_str || l_sep || l_val;
	           	    l_sep := '; ';
	           end if;
	       else
	       	 l_str := l_str || l_sep || l_val;
	         l_sep := '; ';
	       end if;
       end loop;
       close l_cur;

       return l_str;
   end;
 
 