
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TYPESTATUS" (p_key_val in NUMBER )
return varchar2
-- Given a collection object id, returns a concatenated list of the unique type status values that apply to the collection object.
-- @param p_key_val collection object id to look up
-- @return varchar2 containing a semicolon delimited list of unique type status value for the collection object.
-- @see CONCATTYPESTATUS
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);

l_cur rc;
begin
l_str := '';
open l_cur for 'select distinct type_status from citation where citation.collection_object_id  = :x and type_status <> ''figured'' '
using p_key_val;

loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := '; ';
end loop;
close l_cur;

return l_str;
end;