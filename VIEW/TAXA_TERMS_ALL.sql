
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "TAXA_TERMS_ALL" ("COLLECTION_OBJECT_ID", "TAXA_TERM") AS 
  SELECT identification.collection_object_id,
    upper(scientific_name) taxa_term
  FROM identification
  UNION
  SELECT identification.collection_object_id,
    upper(full_taxon_name) taxa_term
  FROM identification,
    identification_taxonomy,
    taxonomy
  WHERE identification.identification_id      = identification_taxonomy.identification_id
  AND identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
  UNION
  select
    collection_object_id,
    upper(attribute_value) taxa_term
    from
    PART_ATTRIBUTES_BY_CATITEM
    where ATTRIBUTE_TYPE = 'scientific name'
    UNION
  SELECT identification.collection_object_id,
    upper(common_name) taxa_term
  FROM identification,
    identification_taxonomy,
    taxonomy,
    common_name
  WHERE identification.identification_id      = identification_taxonomy.identification_id
  AND identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
  AND taxonomy.taxon_name_id                = common_name.taxon_name_id
    UNION
  SELECT citation.collection_object_id, UPPER(TAXONOMY.SCIENTIFIC_NAME) from
    CITATION,
    TAXONOMY
  WHERE CITATION.CITED_TAXON_NAME_ID = TAXONOMY.TAXON_NAME_ID