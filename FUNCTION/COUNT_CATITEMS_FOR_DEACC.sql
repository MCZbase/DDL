
  CREATE OR REPLACE FUNCTION "COUNT_CATITEMS_FOR_DEACC" 
(
  TRANSACTION_ID IN NUMBER    
) 
--  Given a transaction id return the number of cataloged items linked to that deaccession
--  @param transaction_id the primary key value for the deaccession to look up cataloged items for.
--  @return the count of the number of cataloged_items linked to the specified deaccession.
RETURN VARCHAR2 AS 
  type rc is ref cursor;
  ct NUMBER;
  retval  NUMBER;
  l_cur rc;
BEGIN
  retval := 0;
  open l_cur for
       ' select count(*) as ct 
       from cataloged_item
         left outer join specimen_part on cataloged_item.collection_object_id = specimen_part.derived_from_cat_item
         left outer join deacc_item on specimen_part.collection_object_id = deacc_item.collection_object_id
       where deacc_item.transaction_id  = :x '
  using TRANSACTION_ID;
  loop 
       fetch l_cur into ct;
       exit when l_cur%notfound;
       retval := ct;
  end loop;   
  close l_cur;
 RETURN retval;

END COUNT_CATITEMS_FOR_DEACC;