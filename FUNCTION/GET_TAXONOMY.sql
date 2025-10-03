
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_TAXONOMY" (collobjid IN number, rank in varchar2 )
    return varchar2
    -- given a collection object id and a taxonomic rank, return the value of the given rank 
    -- for the current identification of the given collection object, e.g. obtain the family
    -- placement of the current identification on a given collection object.
    -- @param collobjectid the collection_object_id for which to look up the current identification
    -- @param rank the rank (or arbitrary field) in the taxonomy record used in the current identification to look up
    -- @return the value of the provided rank field in the taxonomy table for the taxonomy used 
    -- in the current identification of the specified collection object.
    -- @see get_higher_taxa_lenlimited where this is used
    -- @see get_scientific_name for an alternative assembly for a set scientific name fields
    as
        l_str    varchar2(4000);
	begin
	execute immediate 'select distinct(taxonomy.' || rank || ') tname from identification, identification_taxonomy, taxonomy
		where identification.identification_id = identification_taxonomy.identification_id AND
		identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id AND
		accepted_id_fg=1 AND
		collection_object_id = ' || collobjid into l_str;
	return l_str;
	EXCEPTION
	when TOO_MANY_ROWS then
		l_str := 'undefinable';
		return  l_str;
	when NO_DATA_FOUND then
		l_str := 'not recorded';
		return  l_str;
	when others then
		l_str := 'error!';
		return  trim(l_str);
  end;
  --create public synonym get_taxonomy for get_taxonomy;
  --grant execute on get_taxonomy to public;