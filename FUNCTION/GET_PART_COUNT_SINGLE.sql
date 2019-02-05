
  CREATE OR REPLACE FUNCTION "GET_PART_COUNT_SINGLE" 
( collection_object_id IN VARCHAR2
) RETURN NUMBER 
-- Given a collection_object_id, returns the value of
-- coll_object.lot_count for that SINGLE collection_object.
--
-- @param collection_object_id id of the part for which to obtain a lot count.
-- @return the coll_object.lot count for the selected coll_object, 1 if not found.
as
       type rc is ref cursor;
       l_result number;
       l_cur    rc;
begin
open l_cur for '
select coll_object.lot_count
from coll_object 
where coll_object.collection_object_id  = :x '
        using collection_object_id;

       l_result := 1;
       loop
           fetch l_cur into l_result;
           exit when l_cur%notfound;
       end loop;
       close l_cur;

       return l_result;
END;