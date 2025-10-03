
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_IDENT_REMARKS" (collobjid IN number )
    return varchar2
-- given an collection object id, return the remarks for the current identification of that specimen.
-- utility function to support column not in flat in search results.
-- @param collobjid the collection object id of a cataloged item.
-- @return the current identification remarks.    
as
final_str    varchar2(4000);
begin
FOR rec IN (
select 
  identification_remarks
FROM
identification
WHERE
accepted_id_fg = 1 and
collection_object_id = collobjid)
LOOP
   final_str := rec.identification_remarks;
  END LOOP;
  return  final_str;
EXCEPTION
when others then
final_str := 'error!';
return  final_str;
end;
