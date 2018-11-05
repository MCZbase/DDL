
  CREATE OR REPLACE FUNCTION "GET_FISH_PARTS_COUNTS" 
( collection_object_id IN NUMBER
) RETURN VARCHAR2 
-- Given a collection_object.collection_object_id, returns a string --
-- representing the numbers of Alcohol, Cleared and Stained, and    --
-- skeletal specimen_parts that exist for that collection_object    --
-- in the form "x Alc, y C&S, z Skel.", where x, y and z are either --
-- zero or the number of parts of that preparation type.            --
-- This is for the fish label format that follows the Muse format   --
-- of Alc, C&S, and Skel counts of specimens in each lot [muse      --
-- record].                                                         --
as
       type rc is ref cursor;
       l_str    varchar2(4000);
       l_sep    varchar2(2);
       l_ord    integer;
       l_txt    varchar2(10);
       l_val    INTEGER;
       l_alc_val INTEGER;
       l_cs_val INTEGER;
       l_skel_val integer;
       l_cur    rc;
begin
open l_cur for '
select 1 as ordinal, ''Alc'', sum(coll_object.lot_count)
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
where (preserve_method like ''%ethanol'' or preserve_method like ''%alcohol'' or preserve_method like ''%isopropyl'')
and derived_from_cat_item = :x 
and part_name <> ''tissue''
group by derived_from_cat_item
union
select 2 as ordinal, ''CS'', sum(coll_object.lot_count)
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
where preserve_method like ''%cleared and stained'' 
and derived_from_cat_item = :x1
group by derived_from_cat_item
union
select 3 as ordinal, ''Skel'', sum(coll_object.lot_count)
from specimen_part  
left join coll_object on specimen_part.collection_object_id = coll_object.collection_object_id  
where ( ( part_name like ''%skeleton'' or part_name = ''skull'' ) and ( preserve_method =  ''mounted'' or preserve_method = ''dry'') )
and derived_from_cat_item = :x2
group by derived_from_cat_item'
        using collection_object_id, collection_object_id, collection_object_id;

       l_alc_val := 0;
       l_cs_val := 0;
       l_skel_val := 0;
       loop
           fetch l_cur into l_ord, l_txt, l_val;
           exit when l_cur%notfound;
           if l_ord = 1 then l_alc_val := l_val; end if;
           if l_ord = 2 then l_cs_val := l_val; end if;
           if l_ord = 3 then l_skel_val := l_val; end if;
       end loop;
       close l_cur;
       l_str := l_alc_val || ' Alc, ' || l_cs_val || ' C&S, ' || l_skel_val || ' Skel.';

       return l_str;
END;