
  CREATE OR REPLACE FUNCTION "GET_OTHERID_NUMBER_OFTYPE" ( 
  p_key_val IN NUMBER,
  target_type VARCHAR2
  ) 
-- Given a collection_object_id and an other id type, 
-- returns a semicolon delimited list of the other numbers 
-- (numbers other than the catalog number) that --
-- are associated with that collection_object in the table.field     --
-- coll_obj_other_id_num.display_value.  and have the specified
-- other number type.
-- @param p_key_val the collection_object_id of the cataloged item
-- for which to return other numbers.
-- @param target_type the type of other id values to return.
-- @return a semicolon delimited list of other id values.
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
                          and other_id_type = :y
                        order by display_value'
       using p_key_val, target_type;
       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
end;