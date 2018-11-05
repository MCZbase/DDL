
  CREATE OR REPLACE FUNCTION "CONCATTYPESTATUS_PLAIN_S" (p_key_val in NUMBER, primary in number, secondary in number, voucher in number )
return varchar2
--  Formluate a list of type status and taxon names for the type status consistent
--  with the expectations of dwc:typeStatus for only the specified type status categories.
--  TODO: dwc:typeStatus doesn't expect html markup.
--  TODO: Make separate concattypestatus_label_s to use where markup is desired.
-- 
--  @param p_key_val the collection object id for which to obtain the typestatus value
--  @param primary if greater than 0 show primary types.
--  @param secondary if greater than 0 show secondary types.
--  @param voucher if greater than 0 show vouchers.
as
type rc is ref cursor;
l_str varchar2(4000);
l_sep varchar2(30);
l_val varchar2(4000);
l_cur rc;
begin

open l_cur for 'select distinct citation.type_status || '' of '' || display_name 
from citation 
  left join  formatted_publication on citation.publication_id = formatted_publication.publication_id
  left join taxonomy on citation.cited_taxon_name_id=taxonomy.taxon_name_id
  left join ctcitation_type_status on citation.type_status = ctcitation_type_status.type_status
where
   format_style=''short'' AND
   ((category = ''Primary'' and :a > 0) or (category = ''Secondary'' and :b > 0) or (category = ''Voucher'' and :c > 0) ) and 
   citation.collection_object_id  = :x '
using primary, secondary, voucher, p_key_val;

loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_str || l_sep || l_val;
l_sep := '| ';
end loop;
close l_cur;
return l_str;
end;