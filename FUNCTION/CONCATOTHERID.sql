
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATOTHERID" (p_key_val  in number)
    return varchar2
    as
        type rc is ref cursor;
        l_str_temp varchar(20000);
        l_str    varchar2(4000);
       l_sep    varchar2(2);
       l_val    varchar2(4000);
   		l_cur    rc;
   begin

       open l_cur for 'select other_id_type || ''=''|| display_value
                         from coll_obj_other_id_num
                        where collection_object_id = :x
                        order by other_id_type, display_value'
                   using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str_temp := l_str_temp || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;
       IF l_str_temp IS NULL THEN
            l_str := null;
       ELSIF LENGTH(l_str_temp) > 4000 THEN -- ADDED THIS LINE
            l_str := substr(l_str_temp, 1, 3925) || '}' || l_sep || ' *** THERE ARE ADDITIONAL IDS THAT ARE NOT SHOWN HERE ***'; -- ADDED THIS LINE
        ELSE l_str := l_str_temp;
        END IF;

       return l_str;
   end;