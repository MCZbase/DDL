
  CREATE OR REPLACE FUNCTION "GET_TYPESTATUSFORNAME" (p_key_val in NUMBER, taxonid in NUMBER)
return varchar2
--  Return the list of type status names for some taxon on some specimen
--  Supports production of one label for each taxon name for a specimen with
--  the list of all type status values, instead of one for each type status
--  value.
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);

l_cur rc;
begin
l_str := '';
open l_cur for '
   select distinct type_status from citation 
  where citation.collection_object_id  = :x 
        and type_status <> ''figured'' 
        and citation.taxonid = :y
   '
using p_key_val, taxonid;

loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := '; ';
end loop;
close l_cur;

return l_str;
end;