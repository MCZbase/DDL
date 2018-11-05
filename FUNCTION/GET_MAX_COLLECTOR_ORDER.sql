
  CREATE OR REPLACE FUNCTION "GET_MAX_COLLECTOR_ORDER" (collection_object_id in number)
RETURN NUMBER 
AS 
   pragma autonomous_transaction;
   type rc is ref cursor;
   l_cur rc;
   l_val number;
   retval number;
BEGIN
  open l_cur for ' select max(coll_order) as max from collector where collection_object_id = :x ' 
      using collection_object_id;

  retval := 0;
  loop 
     fetch l_cur into l_val;
     exit when l_cur%notfound;
     retval := l_val;
  end loop;
  close l_cur;
  
  RETURN retval;
  
END GET_MAX_COLLECTOR_ORDER;
 