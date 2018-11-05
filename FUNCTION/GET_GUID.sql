
  CREATE OR REPLACE FUNCTION "GET_GUID" (collobjid IN number )
return varchar2
as
varGuid varchar2(50);
begin

select 'MCZ:' || collection_cde || ':' || cat_num into varGuid from cataloged_item where collection_object_id = collobjid;
return varGuid;
end;