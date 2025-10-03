
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ORPHANEDIDENTIFICATIONS" ("COLLECTION_OBJECT_ID") AS 
  select collection_object_id from Identification
where collection_object_id <> 0 and
collection_object_id not in (
select collection_object_id from Cataloged_item)
 