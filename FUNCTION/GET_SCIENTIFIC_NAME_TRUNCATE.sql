
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_SCIENTIFIC_NAME_TRUNCATE" 
(
  COLLOBJECTID IN NUMBER  
, TRUNCATETO IN NUMBER  
) RETURN VARCHAR2 
AS 
  final_str    varchar2(4000);
  sn varchar(4000);
BEGIN
FOR rec IN (
  select
    taxonomy.scientific_name,
    taxa_formula,
    variable,
    taxonomy.genus, taxonomy.species, taxonomy.subspecies, taxonomy.infraspecific_rank
  FROM
    identification,
    identification_taxonomy,
    taxonomy
  WHERE
    identification.identification_id = identification_taxonomy.identification_id AND
    identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id and
    accepted_id_fg = 1 and
    collection_object_id = COLLOBJECTID)
LOOP
   sn := rec.scientific_name;
   if (final_str is null) then
      final_str := rec.taxa_formula;
   end if;
   final_str := replace(final_str,rec.VARIABLE,rec.scientific_name);
   final_str := replace(final_str,' {string}');

   if length(sn) > TRUNCATETO then
      if length(rec.subspecies) = 0 then 
         final_str := substr(rec.genus || ' ' || substr(rec.species,1,1),1,TRUNCATETO-2) || '...';
      else 
         final_str := rec.genus || ' ' || substr(rec.species,1,1) || '. ' || rec.infraspecific_rank || ' ' || rec.subspecies;
         if length(final_str) > TRUNCATETO then 
            final_str := rec.genus || ' ' || substr(rec.species,1,1) ||  '. ' || rec.subspecies;
            if length(final_str) > TRUNCATETO then 
               final_str := substr(rec.genus || ' ' || substr(rec.species,1,1) ||  '. ' || rec.subspecies,1,TRUNCATETO-2) || '...';
            end if;
         end if;
      end if;
   end if;
END LOOP;   
return  final_str;

EXCEPTION
when others then
final_str := 'error!';
return  final_str;
END GET_SCIENTIFIC_NAME_TRUNCATE;