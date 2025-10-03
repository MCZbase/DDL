
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATTYPESTATUS" (p_key_val in NUMBER )
return varchar2
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);

l_cur rc;
begin

open l_cur for 'select 
		type_status || 
		'' of <a href="http://mczbase.mcz.harvard.edu/name/'' || scientific_name || ''">'' || display_name || ''</a> in <a href="http://mczbase.mcz.harvard.edu/SpecimenUsage.cfm?publication_id='' || citation.publication_id || ''"> '' || formatted_publication || ''</a>''
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
l_sep := '; ';
end loop;
close l_cur;

return l_str;
end;