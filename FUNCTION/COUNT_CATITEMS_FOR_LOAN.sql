
  CREATE OR REPLACE EDITIONABLE FUNCTION "COUNT_CATITEMS_FOR_LOAN" 
(
  TRANSACTION_ID IN NUMBER    
) 
--  Given a transaction id return the number of cataloged items linked to that loan
--  @param transaction_id the primary key value for the loan to look up cataloged items for.
--  @return the count of the number of cataloged_items linked to the specified loan.
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
         left outer join loan_item on specimen_part.collection_object_id = loan_item.collection_object_id
       where loan_item.transaction_id  = :x '
  using TRANSACTION_ID;
  loop 
       fetch l_cur into ct;
       exit when l_cur%notfound;
       retval := ct;
  end loop;   
  close l_cur;
 RETURN retval;

END COUNT_CATITEMS_FOR_LOAN;