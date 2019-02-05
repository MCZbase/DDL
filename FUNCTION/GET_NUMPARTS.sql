
  CREATE OR REPLACE FUNCTION "GET_NUMPARTS" 
( collection_object_id IN VARCHAR2
) RETURN NUMBER 
-- Given a collection_object.collection_object_id of a cataloged_item,
-- return the number of specimen_parts (not the sum of the lot counts) for that collection_object.      
-- if no parts, returns 0                                            
-- @param collection_object_id the collection_object of the parent cataloged_item
-- @return the number of specimen_parts with
--   a derived_from_cata_item equal to the provided collection_object_id
-- @see GET_PART_COUNT for the sum of the lot count
as
       type rc is ref cursor;
       l_result NUMBER;
       l_cur    rc;
begin
open l_cur for '
select count(*)
from specimen_part  
where derived_from_cat_item = :x 
group by derived_from_cat_item'
        using collection_object_id;

       l_result := 0;
       loop
           fetch l_cur into l_result;
           exit when l_cur%notfound;
       end loop;
       close l_cur;

       return l_result;
END;