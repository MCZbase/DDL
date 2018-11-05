
  CREATE OR REPLACE FORCE VIEW "ORPHANEDCOLLECTORS" ("COLLECTION_OBJECT_ID") AS 
  select collection_object_id from Collector
where collection_object_id not in (
select collection_object_id from Cataloged_item)
 