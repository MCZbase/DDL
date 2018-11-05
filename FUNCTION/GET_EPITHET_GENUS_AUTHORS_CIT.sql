
  CREATE OR REPLACE FUNCTION "GET_EPITHET_GENUS_AUTHORS_CIT" (collobjid IN number )
--  Obtain a scientific name with html markup from the highest priority citation for a specimen
--  @param collobjid, the collection object id for which to return the cited name.
   RETURN VARCHAR2 AS 
        final_str    varchar2(4000);
begin
FOR rec IN 
(
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
scientific_name
FROM
citation left join taxonomy on citation.cited_taxon_name_id = taxonomy.taxon_name_id
         left join ctcitation_type_status ct on citation.type_status = ct.type_status
WHERE
   cit_current_fg = 1 and
   citation.collection_object_id = collobjid and 
   rownum < 2 
order by ct.category asc, ct.ordinal asc 
)
LOOP
   final_str := rec.scientific_name;
END LOOP;
  --final_str := REPLACE(final_str,' ','&nbsp;');
  return  final_str;
EXCEPTION
when others then
final_str := 'error!';
return  final_str;
  end;
  --create public synonym get_epithet_genus_authors_cit for get_epithet_genus_authors;
 -- grant execute on get_epithet_genus_authors_cit to public;