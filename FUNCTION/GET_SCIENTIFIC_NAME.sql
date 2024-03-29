
  CREATE OR REPLACE FUNCTION "GET_SCIENTIFIC_NAME" (collobjid IN number )
return varchar2
-- given an collection object id, return the scientific name used in the current identification of that specimen.
-- @param collobjid the collection object id of a cataloged item.
-- @return the current identification as an html formatted string with italics.
as
  final_str    varchar2(4000);
begin
FOR rec IN (
select
   decode(taxonomy.taxon_status, null,
        '<i>' || 
        replace(
            taxonomy.scientific_name,
            taxonomy.infraspecific_rank,
            '</i>' || taxonomy.infraspecific_rank || '<i>') 
        || '</i>', 
    taxonomy.scientific_name    
    ) scientific_name ,
taxa_formula,
variable
FROM
identification,
identification_taxonomy,
taxonomy
WHERE
identification.identification_id = identification_taxonomy.identification_id AND
identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id and
accepted_id_fg = 1 and
collection_object_id = collobjid)
LOOP
   if (final_str is null) then
   final_str := rec.taxa_formula;
   end if;
final_str := replace(final_str,rec.VARIABLE,rec.scientific_name);
final_str := replace(final_str,' {string}');
  END LOOP;
  --final_str := REPLACE(final_str,' ','&nbsp;');
  return  final_str;
EXCEPTION
when others then
final_str := 'error!';
return  final_str;

END GET_SCIENTIFIC_NAME;
--create public synonym get_scientific_name for get_scientific_name;
-- grant execute on get_scientific_name to public;