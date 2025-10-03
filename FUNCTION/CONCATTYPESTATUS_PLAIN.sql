
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATTYPESTATUS_PLAIN" (p_key_val in NUMBER )
return varchar2
--  Formluate a list of type status and taxon names for the type status consistent
--  with the expectations of dwc:typeStatus (type status, type name without markup
--  in a pipe separated list).
--  To be used with feeds for aggregators.  
--
--  @param p_key_val the collection_object_id for which to return type status values.
--  @return varchar containing a pipe delimited list of {type status} of {scientific name} 
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);
l_cur rc;
begin

open l_cur for 'select type_status || '' of '' || scientific_name 
                from citation, formatted_publication,taxonomy
                where citation.publication_id = formatted_publication.publication_id and
                citation.cited_taxon_name_id=taxonomy.taxon_name_id and
                format_style=''short'' AND
                citation.collection_object_id  = :x '
using p_key_val;

loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := '| ';
end loop;
close l_cur;
--  Do not truncate, dwc:typeStatus doesn't have a fixed length.
--        IF LENGTH(l_str) > 255 THEN -- ADDED THIS LINE
--            l_str := substr(l_str, 1, 185) || '}' || l_sep || ' *** THERE ARE ADDITIONAL TYPE STATUSES THAT ARE NOT SHOWN HERE ***'; -- ADDED THIS LINE
--        END IF;
return l_str;
end;