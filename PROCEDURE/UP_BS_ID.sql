
  CREATE OR REPLACE EDITIONABLE PROCEDURE "UP_BS_ID" ( for_staging_user in varchar2)
-- prepare bulkloader_stage records for ingest by changing from the user provided collection_object_id to
-- a unique value from the bulkloader_pkey sequence, for a particular staging user.
-- @param for_staging_user, the username of the user for whom records in bulkloader_staging
-- are to be updated.
-- ? unused ?  
-- @deprecated
			is
			  BEGIN
				FOR rec IN (SELECT collection_object_id FROM bulkloader_stage) LOOP
					update bulkloader_stage set collection_object_id = bulkloader_pkey.nextval
							where collection_object_id=rec.collection_object_id
                            and staging_user = for_staging_user;
				END LOOP;
			END;