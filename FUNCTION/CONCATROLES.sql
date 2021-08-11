
  CREATE OR REPLACE FUNCTION "CONCATROLES" (p_key_val  in varchar2 )
return varchar2
-- Obtain a pipe delimited list of the roles granted in the MCZ space to a grantee, that is,
-- the list of departmental collections to which the user has been granted access.
-- @param p_key_val the grantee username (case sensitive) for which to look up granted roles.
-- @return a varchar containing a pipe delimited list of granted roles, e.g. 'MCZ_BIRD | MCZ_CRYO'
as
type rc is ref cursor;
l_str    varchar2(4000);
l_sep    varchar2(3);
l_val    varchar2(4000);
l_cur    rc;
begin
open l_cur for 'select GRANTED_ROLE
from dba_role_privs
where
grantee = :x
and granted_role like ''MCZ%''
order by GRANTED_ROLE'
using p_key_val;
loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := ' | ';
end loop;
close l_cur;

return l_str;
end;