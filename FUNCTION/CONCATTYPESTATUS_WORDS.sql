
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATTYPESTATUS_WORDS" (p_key_val in NUMBER )
return varchar2
-- Given a collection object id, returns a concatenated list of the type status values that apply to the collection object.
-- @param p_key_val collection object id to look up
-- @return varchar2 containing a comma delimited list of all type status value for the collection object.
-- @see GET_TYPESTATUS
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);

l_cur rc;
begin

open l_cur for 'select citation.type_status 
                from citation
                left join ctcitation_type_status on citation.type_status = ctcitation_type_status.type_status
                where 
                citation.collection_object_id  = :x 
                order by category, ordinal, citation.type_status '
using p_key_val;

l_sep := ' ';
l_str := ' ';
loop
fetch l_cur into l_val;
exit when l_cur%notfound;
   if (instr(l_str,l_val)=0) then 
      l_str := l_str || l_sep || l_val;
      l_sep := ', ';
   end if;
end loop;
close l_cur;

return trim(l_str);
END CONCATTYPESTATUS_WORDS;