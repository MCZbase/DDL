
  CREATE OR REPLACE EDITIONABLE FUNCTION "ALL_TAXON_NAMES" (collobjid  in number )
    return varchar2
    as
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

   for r in (
   	select upper(scientific_name) n from identification where collection_object_id = collobjid
  UNION
  select upper(scientific_name) n from citation, taxonomy where citation.CITED_TAXON_NAME_ID = taxonomy.taxon_name_id AND
       	collection_object_id = collobjid
  UNION
  select upper(full_taxon_name) n from identification, identification_taxonomy, taxonomy
  where
  identification.collection_object_id = collobjid AND
  identification.identification_id = identification_taxonomy.identification_id AND
  identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
  UNION
  select upper(common_name) n from identification, identification_taxonomy, taxonomy, common_name
  where
  identification.collection_object_id = collobjid AND
  identification.identification_id = identification_taxonomy.identification_id AND
  identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id AND
  taxonomy.taxon_name_id = common_name.taxon_name_id
  UNION
  select upper(related.full_taxon_name) n from identification, identification_taxonomy, taxonomy, taxonomy related, taxon_relations
  where
  identification.collection_object_id = collobjid AND
  identification.identification_id = identification_taxonomy.identification_id AND
  identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id AND
  taxonomy.taxon_name_id = taxon_relations.taxon_name_id AND
  taxon_relations.RELATED_TAXON_NAME_ID = related.taxon_name_id)
  LOOP
  	l_str := l_str || l_sep || r.n;
    l_sep := '; ';
  --dbms_output.put_line (r.n);
  END LOOP;
  --l_str := 'bla';
  return l_str;
  end;
  -- call with
  -- select all_taxon_names(19268) from dual;