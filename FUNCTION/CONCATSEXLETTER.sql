
  CREATE OR REPLACE FUNCTION "CONCATSEXLETTER" (p_key_val  in varchar2 )
RETURN VARCHAR2
  AS
  --  To support Mammalogy labels with Single letter M/F for sex.
       type rc is ref cursor;
       l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for 'select attribute_value
                         from attributes
                        where
                        attribute_type=''sex'' and
                        collection_object_id = :x'
                   using p_key_val;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           if (upper(l_val) = 'MALE') then l_val := 'M'; end if;
           if (upper(l_val) = 'FEMALE') then l_val := 'F'; end if;
           if (upper(l_val) = 'MALE ?') then l_val := 'M?'; end if;
           if (upper(l_val) = 'FEMALE ?') then l_val := 'F?'; end if;           
           if (upper(l_val) = 'UNKNOWN') then l_val := 'U'; end if;   
           if (upper(l_val) = 'JUVENILE') then l_val := 'U'; end if;            
           if (upper(l_val) = 'NOT RECORDED') then l_val := ''; end if;           
           l_str := l_str || l_sep || l_val;
           l_sep := ',';
       end loop;
       close l_cur;

       return l_str;

 


END CONCATSEXLETTER;
 