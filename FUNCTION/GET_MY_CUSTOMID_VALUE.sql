
  CREATE OR REPLACE FUNCTION "GET_MY_CUSTOMID_VALUE" (collection_object_id number)
RETURN VARCHAR 
--  obtain the display value of the custom identifier for the current user
--  for the specified cataloged item
--  @param collection_object_id the collection_object_id for the cataloged item 
--    for which to obtain the other id number of the users specified type
--  @return the value of the other id if any for of the users custom type
AS 
  type rc is ref cursor;
  retval    varchar(2000);
  customid varchar(2000);
  l_cur    rc;
BEGIN
      retval := ''; 
      select mczbase.get_my_customid() into customid from dual;
      open l_cur for '
      select display_value from coll_obj_other_id_num
      where collection_object_id = :x
         and other_id_type = :y
      '
      using collection_object_id, customid;
      loop
           fetch l_cur into retval;
           exit when l_cur%notfound; 
      end loop;
      close l_cur;

      return retval;
END GET_MY_CUSTOMID_VALUE;
