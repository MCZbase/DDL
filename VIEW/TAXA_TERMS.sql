
  CREATE OR REPLACE FORCE VIEW "TAXA_TERMS" ("COLLECTION_OBJECT_ID", "TAXA_TERM") AS 
  select
identification.collection_object_id,
upper(scientific_name) taxa_term
from
identification
where accepted_id_fg=1
UNION
select
identification.collection_object_id,
upper(full_taxon_name) taxa_term
from
identification,
identification_taxonomy,
taxonomy
where
accepted_id_fg=1 AND
identification.identification_id = identification_taxonomy.identification_id AND
identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
UNION
select
collection_object_id,
upper(attribute_value) taxa_term
from
PART_ATTRIBUTES_BY_CATITEM
UNION
select
identification.collection_object_id,
upper(common_name) taxa_term
from
identification,
identification_taxonomy,
taxonomy,
common_name
where
accepted_id_fg=1 AND
identification.identification_id = identification_taxonomy.identification_id AND
identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id AND
taxonomy.taxon_name_id = common_name.taxon_name_id