
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATOTHERID_EXCLUDE" (p_key_val in number, exclusion_list in varchar2)
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(2);
       l_val    varchar2(4000);
      l_type    varchar2(4000);
   		l_cur    rc;
   begin

       open l_cur for 'select other_id_type || ''=''|| display_value, other_id_type
                         from coll_obj_other_id_num
                        where collection_object_id = :x
                        order by other_id_type, display_value'
                   using p_key_val;

       loop
           fetch l_cur into l_val, l_type;
           exit when l_cur%notfound;
           if instr(exclusion_list,l_type) = 0 then 
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
           end if;
       end loop;
       close l_cur;

       return l_str;
   end;
 