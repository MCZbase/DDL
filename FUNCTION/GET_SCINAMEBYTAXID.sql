
  CREATE OR REPLACE FUNCTION "GET_SCINAMEBYTAXID" (taxonnameid IN number )
return varchar2
as
varScientificName taxonomy.scientific_name%TYPE;
begin

select scientific_name into varScientificName from taxonomy where taxon_name_id  = taxonnameid;
return varscientificname;
end;