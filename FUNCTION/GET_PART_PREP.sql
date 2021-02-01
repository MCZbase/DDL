
  CREATE OR REPLACE FUNCTION "GET_PART_PREP" 
(
  COLLECTION_OBJECT_ID IN NUMBER  
) RETURN VARCHAR2 
-- Given a specimen_part.collection_object_id, returns the part name, --
-- modifier, and preserve_method concatenated as a string.            --
as
       type rc is ref cursor;
       l_result varchar(255);
       l_cur    rc;
       pn varchar(100);
       pr varchar(50);
begin
open l_cur for '
select part_name, 
       decode(preserve_method,'''','''','' ('') || preserve_method || decode(preserve_method,'''','''','')'')
from specimen_part  
where collection_object_id = :x '
        using collection_object_id;

       l_result := '';
       loop
           fetch l_cur into pn, pr;
           l_result := pn || pr ;
           exit when l_cur%notfound;
       end loop;
       close l_cur;

       return l_result;
END GET_PART_PREP;