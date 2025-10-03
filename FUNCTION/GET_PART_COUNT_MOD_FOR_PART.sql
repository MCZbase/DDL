
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PART_COUNT_MOD_FOR_PART" 
( collection_object_id IN VARCHAR2
) RETURN VARCHAR2 
-- Given a specimen_part.collection_object_id, returns the lot count
-- along with the lot count modifier for that specimen_parts collection_object
as
       type rc is ref cursor;
       l_result varchar2(4000);
       l_ct varchar2(10);
       l_mod varchar2(50);
       l_sep varchar2(10);
       l_cur    rc;
begin
open l_cur for '
select coll_object.lot_count, coll_object.lot_count_modifier
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
where specimen_part.collection_object_id = :x 
'
        using collection_object_id;

       l_result := ' ';
       l_sep := ' ';
       loop
           fetch l_cur into l_ct, l_mod;
           exit when l_cur%notfound;
           l_result := trim(l_result || l_sep || l_mod || l_ct);
           l_sep := ' and ';
       end loop;
       if (length(trim(l_result)) = 0) then 
           l_result := '1';
       end if;
       close l_cur;

       return l_result;
END GET_PART_COUNT_MOD_FOR_PART;