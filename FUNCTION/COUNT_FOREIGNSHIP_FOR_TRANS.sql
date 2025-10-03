
  CREATE OR REPLACE EDITIONABLE FUNCTION "COUNT_FOREIGNSHIP_FOR_TRANS" 
(
  TRANSACTION_ID IN NUMBER    
) 
--  Given a transaction id return the number of foreign shipments for that transaction
--  @param transaction_id the primary key value for the transaction to look up permits for.
--  @return the count of the number of foreign shipments linked to the specified transaction.
RETURN VARCHAR2 AS 
  type rc is ref cursor;
  ct NUMBER;
  retval  NUMBER;
  l_cur rc;
BEGIN
  retval := 0;
  open l_cur for
       ' select count(*) as ct 
       from shipment 
       where transaction_id = :x 
       and foreign_shipment_fg > 0'
  using TRANSACTION_ID;
  loop 
       fetch l_cur into ct;
       exit when l_cur%notfound;
       retval := ct;
  end loop;   
  close l_cur;
 RETURN retval;

END COUNT_FOREIGNSHIP_FOR_TRANS;