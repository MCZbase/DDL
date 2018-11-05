
  CREATE OR REPLACE FUNCTION "SUMPARTS" ( collobjid in integer)
return number
as
 result number;
begin
select sum(lot_count) into result 
from coll_object co, specimen_part sp 
where co.collection_object_id = sp.collection_object_id
and sp.derived_from_cat_item = collobjid;

return result;
end;
 