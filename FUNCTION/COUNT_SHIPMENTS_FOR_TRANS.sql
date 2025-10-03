
  CREATE OR REPLACE EDITIONABLE FUNCTION "COUNT_SHIPMENTS_FOR_TRANS" 
(
  TRANSACTION_ID IN NUMBER    
) 
--  Given a transaction id return the number of shipments for that transaction, used to determine
--  whether to print shipment block on header paperwork.
--  @param transaction_id the primary key value for the transaction to look up permits for.
--  @return the count of the number of shipments linked to the specified transaction.
RETURN VARCHAR2 AS 
  type rc is ref cursor;
  ct NUMBER;
  retval  NUMBER;
  l_cur rc;
BEGIN
  retval := 0;
  open l_cur for
       ' select count(*) as ct from shipment where transaction_id = :x '
  using TRANSACTION_ID;
  loop 
       fetch l_cur into ct;
       exit when l_cur%notfound;
       retval := ct;
  end loop;   
  close l_cur;
 RETURN retval;

END COUNT_SHIPMENTS_FOR_TRANS;