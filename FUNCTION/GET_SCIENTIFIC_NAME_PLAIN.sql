
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_SCIENTIFIC_NAME_PLAIN" (collobjid IN number )
    return varchar2
-- given an collection object id, return the scientific name used in the current identification of that specimen excluding the authorship.
-- @param collobjid the collection object id of a cataloged item.
-- @return the current identification as plain text in a form suitable for use in a /name/ link.    
    as
        final_str    varchar2(4000);
BEGIN
    FOR rec IN (
        SELECT
            taxonomy.scientific_name,
            taxa_formula,
            variable
        FROM
            identification,
            identification_taxonomy,
            taxonomy
        WHERE
            identification.identification_id = identification_taxonomy.identification_id
            AND identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
            AND accepted_id_fg = 1
            AND collection_object_id = collobjid
    ) LOOP
        IF ( final_str IS NULL ) THEN
            final_str := rec.taxa_formula;
        END IF;
        final_str := replace(
                            final_str,
                            rec.variable,
                            rec.scientific_name
                     );
        final_str := replace(
                            final_str,
                            ' {string}'
                     );
    END LOOP;
    RETURN final_str;
EXCEPTION
    WHEN OTHERS THEN
        final_str := 'error!';
        RETURN final_str;
END;
-- create public synonym get_scientific_name_plain for mczbase.get_scientific_name_plain;
-- grant execute on get_scientific_name_plain to public;