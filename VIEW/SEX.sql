
  CREATE OR REPLACE FORCE VIEW "SEX" ("COLLECTION_OBJECT_ID", "SEX") AS 
  (
	select collection_object_id,
	ConcatSex(collection_object_id) sex
	FROM attributes
	)
 