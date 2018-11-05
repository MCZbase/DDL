
  CREATE OR REPLACE FUNCTION "GET_CONTIGUOUS" 
(
  COLLECTIONOBJECTID IN NUMBER  
, IDLIST IN VARCHAR2  
) RETURN VARCHAR2  
    as
       type rc is ref cursor;
       l_str    varchar2(4000);
       target    varchar2(200);
       targetn NUMBER;
       l_val    varchar2(4000);
       l_valn   NUMBER;
       previous NUMBER;
       inrange  number;
       l_cur    rc;
       r_cur    rc;
   begin
        open l_cur for 'select cat_num, cat_num_integer from cataloged_item where collection_object_id in (' || IDLIST || ')';
        open r_cur for 'select cat_num, cat_num_integer from cataloged_item where collection_object_id = ' || COLLECTIONOBJECTID ;
        previous := 0;
        inrange := 0;
        fetch r_cur into target, targetn;
       loop
           fetch l_cur into l_val, l_valn;
           exit when l_cur%notfound;
              if previous = 0 then 
                  previous := l_valn - 1; 
              end if;
              if previous = l_valn - 1 then 
                 l_str := l_str || l_val;
                 if l_val = target then 
                     inrange := 1;
                 end if;                 
              else 
                 if inrange=1 then exit; end if ;
                 l_str := l_val;
              end if;
              previous := l_valn;
       end loop;

       close l_cur;

       return l_str;
END GET_CONTIGUOUS;
--create public synonym get_contiguous for get_contiguous;
-- grant execute on get_contiguous to public;
 