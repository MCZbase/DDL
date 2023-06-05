
  CREATE OR REPLACE FORCE VIEW "VIEW_ALL_RELATIONS" ("COLLECTION_OBJECT_ID", "RELATED_COLL_OBJECT_ID", "BIOL_INDIV_RELATIONSHIP", "BIOL_INDIV_RELATION_REMARKS", "CREATED_BY", "BIOL_INDIV_RELATIONS_ID") AS 
  select collection_object_id, related_coll_object_id, biol_indiv_relationship, biol_indiv_relation_remarks, created_by, biol_indiv_relations_id
from biol_indiv_relations 
union
select related_coll_object_id as collection_object_id, collection_object_id as related_coll_object_id, inverse_relation as biol_indiv_relationship, biol_indiv_relation_remarks, created_by, biol_indiv_relations_id
from biol_indiv_relations 
left join ctbiol_relations on biol_indiv_relations.biol_indiv_relationship = ctbiol_relations.biol_indiv_relationship