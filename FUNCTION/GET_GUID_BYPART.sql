
  CREATE OR REPLACE FUNCTION "GET_GUID_BYPART" (collobjid IN number )
return varchar2
-- obtain the base guid (MCZ:{collectionCode}:{catalogNumber} for an
-- MCZbase cataloged item record, without a urn:catalog or resolvable http prefix
-- from the collection object id of a component part of that cataloged item
-- (join on specimen_part.derived_from_cat_item).
-- @param collobjid the collection object id for a component part of the 
--   cataloged item for which to return the guid.
-- @return a guid in the form of a darwin core triplet MCZ:{collectionCode}:{catalogNumber}
as
varGuid varchar2(50);
begin

select 'MCZ:' || ci.collection_cde || ':' || ci.cat_num into varGuid 
from cataloged_item ci, specimen_part sp 
where ci.collection_object_id = SP.DERIVED_FROM_CAT_ITEM
and sp.collection_object_id = collobjid;
return varGuid;
end;