
  CREATE OR REPLACE FUNCTION "GET_TOP_TYPESTATUS" (collection_object_id in NUMBER )
return varchar2
--  Obtain the single most important type status term from the citations of a
--  collection object, if any, otherwise return an empty string.
--  @param collection_object_id the collection object id for the cataloged item for which to
--    return the most important type status.
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);
l_cur rc;
begin
l_str := '';
open l_cur for '
     select type_status from (
     select ct.type_status from citation ci
      left join ctcitation_type_status ct on ci.type_status = ct.type_status
      where ci.collection_object_id  = :x 
      order by ct.category asc, ct.ordinal asc 
     ) where rownum < 2'
using collection_object_id;

loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := '; ';
end loop;
close l_cur;

return l_str;
end;