
  CREATE OR REPLACE FUNCTION "GET_PART_COUNT_PRESERVE" 
( collection_object_id IN VARCHAR2, preserve in varchar2
) RETURN NUMBER 
-- Given a collection_object.collection_object_id, returns the number --
-- of specimen_parts for that collection_object.           --
-- if no parts, returns 1                                             --
as
       type rc is ref cursor;
       l_result NUMBER;
       l_cur    rc;
begin
open l_cur for '
select sum(coll_object.lot_count)
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
where derived_from_cat_item = :x and lower(preserve_method) = lower(:y) 
group by derived_from_cat_item'
        using collection_object_id, preserve;

       l_result := 0;
       loop
           fetch l_cur into l_result;
           exit when l_cur%notfound;
       end loop;
       close l_cur;

       return l_result;
END;