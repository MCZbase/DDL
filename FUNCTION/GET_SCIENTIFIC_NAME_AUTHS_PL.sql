
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_SCIENTIFIC_NAME_AUTHS_PL" (collobjid IN number )
    return varchar2
-- given an collection object id, return the scientific name used in the current identification of that specimen including the authorship.
-- @param collobjid the collection object id of a cataloged item.
-- @return the current identification as plain text.    
    as
        final_str    varchar2(4000);
begin
FOR rec IN (
select 
decode (genus, null, 
    taxonomy.scientific_name,
    decode(taxon_status, null,
        taxonomy.scientific_name,
        taxonomy.scientific_name)
) ||
decode(taxonomy.species,
   null,'',
   decode(author_text,
       NULL,'',
       ' ' || trim(author_text)
    )
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
  end;
  --create public synonym get_scientific_name_auths_plain for get_scientific_name_auths_plain;
 -- grant execute on get_scientific_name_auths_plain to public;