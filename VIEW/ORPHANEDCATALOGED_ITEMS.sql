
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ORPHANEDCATALOGED_ITEMS" ("COLLECTION_OBJECT_ID") AS 
  select collection_object_id from Cataloged_Item
where collection_object_id not in (
select collection_object_id from Coll_Object)
 