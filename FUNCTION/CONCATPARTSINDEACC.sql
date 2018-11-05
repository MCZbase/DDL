
  CREATE OR REPLACE FUNCTION "CONCATPARTSINDEACC" 
(
  COLLECTION_OBJECT_ID IN NUMBER  
, TRANSACTION_ID IN NUMBER  
) 
--  List counts for parts of a cataloged item in a deaccession.
--
--  Given a collection_object_id (probably from specimen_part.derived_from_cat_item)
--  and a transaction_id (for a loan), return counts and part/preparation for all of
--  the specimen parts that are associated with the referenced cataloged item and 
--  that are in the deaccession.  
RETURN VARCHAR2 
AS 
       type rc is ref cursor;
       lotcount VARCHAR2(255);
       partname VARCHAR2(4000);
       preservemethod VARCHAR2(4000);       
       l_result VARCHAR2(4000);
       separator VARCHAR2(4);
       l_cur    rc;
begin
open l_cur for '
select sum(coll_object.lot_count), part_name, preserve_method
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
left join deacc_item on deacc_item.collection_object_id = specimen_part.collection_object_id
where derived_from_cat_item = :x and transaction_id = :y
group by derived_from_cat_item, part_name, preserve_method'
        using collection_object_id, transaction_id;
       l_result := '';
       separator := '';
       loop
           fetch l_cur into lotcount, partname, preservemethod;
           exit when l_cur%notfound;
           l_result := l_result || separator || lotcount || '  ' || partname || ' (' || preservemethod || ')' ;
           separator := '<BR>';
       end loop;
       close l_cur;
       return l_result;
END CONCATPARTSINDEACC;