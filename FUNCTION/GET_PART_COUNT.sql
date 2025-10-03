
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PART_COUNT" 
( collection_object_id IN VARCHAR2
) RETURN NUMBER 
-- Given a collection_object.collection_object_id, returns the total of the 
-- lot count for all of the specimen_parts for that collection_object.      
-- if no parts, returns 1                                             
-- @param collection_object_id the collection_object of the parent cataloged_item
-- @return the sum of the coll_object.lot_count for all of the specimen_parts with
--   a derived_from_cata_item equal to the provided collection_object_id
--  
-- @see GET_NUMPARTS for the count of the number of specimen_part records.
-- @see SUMPARTS for the same query, but a return of null if there are no parts.
as
       type rc is ref cursor;
       l_result NUMBER;
       l_cur    rc;
begin
open l_cur for '
select sum(coll_object.lot_count)
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
where derived_from_cat_item = :x 
group by derived_from_cat_item'
        using collection_object_id;

       l_result := 1;
       loop
           fetch l_cur into l_result;
           exit when l_cur%notfound;
       end loop;
       close l_cur;

       return l_result;
END;