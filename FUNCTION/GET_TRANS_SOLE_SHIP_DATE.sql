
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TRANS_SOLE_SHIP_DATE" (transaction_id IN NUMBER) 
RETURN DATE
-- Given a transaction_id, if that transaction has a single shipment date,   --
-- return the date of that single shipment (or same date of multiple shipments) --
-- @param p_key_val the transaction_id for which to return the sole shipment date.  --
-- @return the shipment data for a sole shipment for the transaction, otherwise null
AS
   type rc is ref cursor;
   retval  DATE;
   counter NUMBER;
   l_cur    rc;
begin
   retval := TO_DATE(null);
   open l_cur for '
     select distinct shipped_date from shipment
     where shipment.transaction_id = :x
   '
   using transaction_id;
   counter := 0;
   loop
      fetch l_cur into retval;
      exit when l_cur%notfound;
      counter := counter + 1;
   end loop;
   close l_cur;
   if counter > 1 then
      retval := TO_DATE(null);
   end if;
   return retval;
END;