
  CREATE OR REPLACE FUNCTION "CONCATPARTCTINLOAN" 
(
  COLLECTION_OBJECT_ID IN NUMBER  
, TRANSACTION_ID IN NUMBER  
) 
--  Obtain count of parts of a cataloged item in a loan.
--
--  Given a collection_object_id (probably from specimen_part.derived_from_cat_item)
--  and a transaction_id (for a loan), return counts for all of
--  the specimen parts that are associated with the referenced cataloged item and 
--  that are in the loan.  
RETURN NUMBER 
AS 
       type rc is ref cursor;
       lotcount NUMBER;      
       l_result NUMBER;
       l_cur    rc;
begin
open l_cur for '
select sum(coll_object.lot_count)
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
left join loan_item on loan_item.collection_object_id = specimen_part.collection_object_id
where derived_from_cat_item = :x and transaction_id = :y
group by derived_from_cat_item, part_name, preserve_method'
        using collection_object_id, transaction_id;
       l_result := 0;
       loop
           fetch l_cur into lotcount;
           exit when l_cur%notfound;
           l_result := l_result +  lotcount;
       end loop;
       close l_cur;
       return l_result;
END;