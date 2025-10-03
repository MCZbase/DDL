
  CREATE OR REPLACE EDITIONABLE FUNCTION "SUMPARTS" ( collobjid in integer)
return number
-- Used by update flat.
-- Obtains the sum of the lot counts for a set of specimen parts that
-- share the same derived_from_cat_item.
-- 
-- @param collobjid the value specimen_part.derived_from_cat_item to find.
-- @returns sum(lot_count) or null if there are no parts.
--
-- @see MCZBASE.GET_PART_COUNT() which is similar but returns 1 when there are no parts.
as
 result number;
begin
select sum(lot_count) into result 
from coll_object co, specimen_part sp 
where co.collection_object_id = sp.collection_object_id
and sp.derived_from_cat_item = collobjid;

return result;
end;