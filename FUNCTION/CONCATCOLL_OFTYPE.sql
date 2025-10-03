
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATCOLL_OFTYPE" (p_key_val  in varchar2, name_type in varchar2)
return varchar2
--  Obtain a string containing an ordered list of collectors for a collection object,
--  where the collector names are provided in the specified form if available.
as
type rc is ref cursor;
l_str    varchar2(4000);
l_sep    varchar2(3);
l_val    varchar2(4000);
l_cur    rc;
begin
open l_cur for 'select mczbase.get_agentnameoftype(agent_id, :x )
from collector
where
collector_role=''c'' AND
collection_object_id = :y
order by coll_order'
using name_type, p_key_val;
loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := '; ';
end loop;
close l_cur;

return l_str;
end;