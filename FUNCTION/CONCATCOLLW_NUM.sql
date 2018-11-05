
  CREATE OR REPLACE FUNCTION "CONCATCOLLW_NUM" (p_key_val  in varchar2 )
return varchar2
as
type rc is ref cursor;
l_str    varchar2(4000);
l_sep    varchar2(3);
l_val    varchar2(4000);
l_cur    rc;
begin
open l_cur for 'select agent_name,other_id_num,other_id_type
from preferred_agent_name,collector,coll_obj_other_id_num
where
collector_role=''c'' AND
OTHER_ID_TYPE in (''collector number'',''preparator number'') AND
collector.agent_id=preferred_agent_name.agent_id AND
collector.collection_object_id=coll_obj_other_id_num.collection_object_id (+) AND
collector.collection_object_id = :x
order by coll_order'
using p_key_val;
loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := ', ';
end loop;
close l_cur;
       return l_str;
  end;
 
 