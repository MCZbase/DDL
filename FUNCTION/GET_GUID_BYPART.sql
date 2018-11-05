
  CREATE OR REPLACE FUNCTION "GET_GUID_BYPART" (collobjid IN number )
return varchar2
as
varGuid varchar2(50);
begin

select 'MCZ:' || ci.collection_cde || ':' || ci.cat_num into varGuid 
from cataloged_item ci, specimen_part sp 
where ci.collection_object_id = SP.DERIVED_FROM_CAT_ITEM
and sp.collection_object_id = collobjid;
return varGuid;
end;