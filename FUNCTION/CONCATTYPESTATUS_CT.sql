
  CREATE OR REPLACE FUNCTION "CONCATTYPESTATUS_CT" (p_key_val in NUMBER )
return varchar2
-- Given a collection object id, returns a concatenated list of the 
-- type status and names that apply to the collection object, with counts for the number of instances
-- without the citation.
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
open l_cur for '
    SELECT citation.type_status || '' of '' || display_name || '' '' || author_text || decode(count(*),1,'''','' ('' || count(*) || '')'') type_status 
    FROM citation 
       left join taxonomy on citation.cited_taxon_name_id=taxonomy.taxon_name_id
       left join ctcitation_type_status on citation.type_status = ctcitation_type_status.type_status
    WHERE collection_object_id = :x
    GROUP BY citation.type_status, display_name, author_text, category, ordinal
    ORDER BY category, ordinal asc
   '
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