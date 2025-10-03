
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_STARTPAGE" (pubid IN number )
return varchar2
as
varStartPage publication_attributes.pub_att_value%TYPE;
begin

select pub_att_value into varStartPage from publication_attributes where publication_id = pubid and publication_attribute = 'begin page';
return varStartPage;
end;