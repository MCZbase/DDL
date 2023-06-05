
  CREATE OR REPLACE FUNCTION "GET_CATITEM_MEDIA_COUNT" (collection_object_id in NUMBER )
return varchar2
-- Given a collection object id, returns a concatenated list of the 
-- media relatioships for that cataloged item, with the number of media objects
-- for each relationship
-- @param p_key_val collection object id to look up
-- @return varchar2 containing a semicolon delimited list of the media relationships for that item
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);

l_cur rc;
begin
l_str := '';
open l_cur for '
    SELECT media_relationship || '' ('' || count(*) || '')'' 
    FROM media_relations 
    WHERE related_primary_key = :x
       and media_relationship like ''% cataloged_item''
    GROUP BY media_relationship 
    ORDER BY media_relationship desc
   '
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