
  CREATE OR REPLACE FUNCTION "GET_OTHERID_NOTCOLL_CONCAT" ( p_key_val IN NUMBER ) 
-- Given a collection_object_id, returns a semicolon delimited list  -- 
-- of the other numbers, excluding the collector number, that --
-- are associated with that collection_object in the table.field     --
-- coll_obj_other_id_num.display_value.  Differs from the function   --
-- CONCATOTHERID(p_key_val) in that only the numbers themselves are  --
-- returned, not the number types and the numbers.  --
-- Differs from the function   --
-- GET_OTHERID_NUMBERS_CONCAT(p_key_val) in that any number typed as the  --
-- collector number is excluded --
-- TODO: Exclude aribtrary list. --
return varchar2
    as
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(2);
      l_val    varchar2(4000);
      l_cur    rc;
   begin
       open l_cur for 'select display_value
                       from coll_obj_other_id_num
                        where collection_object_id = :x
                          and other_id_type <> ''collector number''
                        order by other_id_type, display_value'
       using p_key_val;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
end;