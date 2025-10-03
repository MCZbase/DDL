
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_CATNUM" (collobjid IN number )
return varchar2
as
varCatNum cataloged_item.cat_num%TYPE;
begin

select cat_num into varCatNum from cataloged_item where collection_object_id = collobjid;
return varCatNum;
end;