
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_STORED_AS_ID" (collobjid in number) 
return varchar2 
as
varStoredAs identification.scientific_name%type;
-- Given a collection object_id for a cataloged item, return the identification under which
-- this cataloged item is stored.
-- @param collobjid the collection object id for which to look up the stored as identification.
-- @return a varchar containing the identification under which the cataloged item is stored.
begin
   select scientific_name into varStoredAs 
   from identification 
   where STORED_AS_FG = 1 
     and collection_object_id = collobjid
     and rownum < 2 -- prevent any error cases of specimen with two stored_as identifications hanging up update flat.
;

return varStoredAs;
end;