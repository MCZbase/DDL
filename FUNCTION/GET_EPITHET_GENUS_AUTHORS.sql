
  CREATE OR REPLACE FUNCTION "GET_EPITHET_GENUS_AUTHORS" (collobjid IN number )
   RETURN VARCHAR2 AS 
        final_str    varchar2(4000);
begin
FOR rec IN (
select
'<strong><i>' || 
  decode(taxonomy.subspecies,
     NULL, decode(taxonomy.species,NULL,'',taxonomy.species), 
     taxonomy.subspecies || decode(taxonomy.infraspecific_rank,NULL,'', '</i> ' || taxonomy.infraspecific_rank || '<i>')
  )
  || ', ' ||
  taxonomy.genus || ' ' ||
  decode(taxonomy.subspecies,
     NULL, '', 
     decode(taxonomy.species,NULL,'',taxonomy.species)
  )  
  || '</i>' || decode(author_text,
     NULL,'',
     ' ' || trim(replace(author_text,'&','&amp;'))
  ) 
|| '</strong>'  
scientific_name ,
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
  --create public synonym get_epithet_genus_authors for get_epithet_genus_authors;
 -- grant execute on get_epithet_genus_authors to public;