
  CREATE OR REPLACE EDITIONABLE FUNCTION "COUNT_CATITEMS_FOR_ACCN" 
(
  TRANSACTION_ID IN NUMBER    
) 
--  Given a transaction id return the number of cataloged items linked to that accession
--  @param transaction_id the primary key value for the accession to look up cataloged items for.
--  @return the count of the number of cataloged_items linked to the specified accession.
RETURN VARCHAR2 AS 
  type rc is ref cursor;
  ct NUMBER;
  retval  NUMBER;
  l_cur rc;
BEGIN
  retval := 0;
  open l_cur for
       ' select count(*) as ct from cataloged_item where accn_id  = :x '
  using TRANSACTION_ID;
  loop 
       fetch l_cur into ct;
       exit when l_cur%notfound;
       retval := ct;
  end loop;   
  close l_cur;
 RETURN retval;

END COUNT_CATITEMS_FOR_ACCN;