
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_GUID" (collobjid IN number )
return varchar2
-- obtain the base guid (MCZ:{collectionCode}:{catalogNumber} for an
-- MCZbase cataloged item record, without a urn:catalog or resolvable http prefix.
-- @param collobjid the collection object id for the cataloged item for which to return the guid.
-- @return a guid in the form of a darwin core triplet MCZ:{collectionCode}:{catalogNumber}
as
varGuid varchar2(50);
begin
    select 'MCZ:' || collection_cde || ':' || cat_num into varGuid from cataloged_item where collection_object_id = collobjid;
return varGuid;
end;