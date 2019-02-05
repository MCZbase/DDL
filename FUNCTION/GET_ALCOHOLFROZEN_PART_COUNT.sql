
  CREATE OR REPLACE FUNCTION "GET_ALCOHOLFROZEN_PART_COUNT" 
( collection_object_id IN VARCHAR2
) RETURN NUMBER 
-- Given a collection_object.collection_object_id, returns the number 
-- of specimen_parts in Alcohol or Frozen for that collection_object.           
-- if no parts, returns 1.  Embeds a set of strings such as '%alchohol' 
-- that are presumed to be capable of identifying all frozen or alcoholic material.
-- 
-- @param collection_object_id the collection_object_id for the collection object to lookup
-- @return the sum of the lot count of the parts in alchohol or frozen, or 1 if none are found.
as
       type rc is ref cursor;
       l_result number;
       l_cur    rc;
begin
open l_cur for '
select sum(coll_object.lot_count)
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
where (preserve_method like ''%ethanol'' or preserve_method like ''%alcohol'' or preserve_method like ''%isopropyl'' or preserve_method like ''%isopropanol'' or preserve_method like ''%formalin'' or preserve_method like ''%EtOH'' or preserve_method like ''%frozen%'')
and derived_from_cat_item = :x 
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