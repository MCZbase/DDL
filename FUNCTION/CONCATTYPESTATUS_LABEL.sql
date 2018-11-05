
  CREATE OR REPLACE FUNCTION "CONCATTYPESTATUS_LABEL" (p_key_val in NUMBER )
return varchar2
--  Formluate a list of type status and taxon names for the type status 
--  formatted appropriately for printing on labels (returns just primary and 
--  secondary type status values).
--
--  @param p_key_val collection_object_id for which to find type names
--  @return a formatted list of type status names (set label control to expand to show all)
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);
l_cur rc;
begin

open l_cur for 'select citation.type_status || '' of '' || display_name || '' '' || author_text
                from citation 
                left join formatted_publication on citation.publication_id = formatted_publication.publication_id
                left join taxonomy on citation.cited_taxon_name_id=taxonomy.taxon_name_id
                left join ctcitation_type_status on citation.type_status = ctcitation_type_status.type_status
                where 
                format_style=''short'' AND
                (ctcitation_type_status.category = ''Primary'' OR ctcitation_type_status.category = ''Secondary'') AND
                citation.collection_object_id  = :x 
                order by ctcitation_type_status.category, ctcitation_type_status.ordinal, citation.type_status '
using p_key_val;

loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
--  Caution: <BR> as a separator between names is used in label queries to limit to only the first name, do not change.
l_sep := '<BR>';
end loop;
close l_cur;
---       DO NOT Truncate here.
--        IF LENGTH(l_str) > 255 THEN -- ADDED THIS LINE
--            l_str := substr(l_str, 1, 185) || '}' || l_sep || ' *** THERE ARE ADDITIONAL TYPE STATUSES ***'; -- ADDED THIS LINE
--        END IF;
return l_str;
end;