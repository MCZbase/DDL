
  CREATE OR REPLACE FUNCTION "GET_PART_COUNT_SINGLE_MOD" ( collection_object_id IN VARCHAR2
)
RETURN VARCHAR2 AS 
-- Given a collection_object_id, returns the 
-- coll_object.lot_count with modifier for that collection_object_id.
       type rc is ref cursor;
       l_result varchar(4000);
       l_cur    rc;
begin
open l_cur for '
select decode(coll_object.lot_count_modifier,null,'' '',coll_object.lot_count_modifier) || coll_object.lot_count
from coll_object 
where coll_object.collection_object_id  = :x '
        using collection_object_id;

       l_result := '1';
       loop
           fetch l_cur into l_result;
           exit when l_cur%notfound;
       end loop;
       close l_cur;

       return l_result;
END GET_PART_COUNT_SINGLE_MOD;
 