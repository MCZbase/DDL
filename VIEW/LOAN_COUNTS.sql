
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "LOAN_COUNTS" ("TRANSACTION_ID", "NUM_LOTS", "NUM_SPECIMENS") AS 
  select transaction_id, 
  count(distinct specimen_part.derived_from_cat_item) as num_lots, 
  sum(lot_count) as num_specimens
from loan_item, coll_object, specimen_part
where loan_item.collection_object_id = coll_object.collection_object_id
and coll_object.collection_object_id = specimen_part.collection_object_id
group by transaction_id