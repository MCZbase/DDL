
  CREATE OR REPLACE EDITIONABLE PROCEDURE "IS_FLAT_STALE" 
-- Update records in FLAT and update the keyword indexes.
-- Takes up to 5000 records in FLAT where stale_flag = 1
-- and runs update_flat on them, then updates the keyword indexes.
-- Note: FLAT.stale_flag is normally 0, gets set to 1 by triggers when
-- data changes, and can be set manually to 2 or higher to isolate or
-- identify records that have problems raised from update_flat.
IS 
    aid NUMBER;
BEGIN
        FOR r IN (
                SELECT 
                    collection_object_id,
                    lastuser,
                    lastdate 
                FROM 
                    flat 
                WHERE 
                    stale_flag = 1 AND 
                    ROWNUM < 5000
        ) LOOP
                -- dbms_output.put_line(r.collection_object_id);
                -- update flat_media set stale_fg=1 where collection_object_id = r.collection_object_id;
                update_flat(r.collection_object_id);
                BEGIN
                    IF r.lastuser='UAM' or r.lastuser ='MCZBASE' THEN
                        aid:=0;
                    ELSE
                        SELECT agent_id INTO aid FROM agent_name WHERE agent_name_type='login' AND upper(agent_name)=upper(r.lastuser);
                    END IF;
                    UPDATE coll_object SET 
                        LAST_EDITED_PERSON_ID=aid,
                        LAST_EDIT_DATE=r.lastdate
                    WHERE
                        collection_object_id = r.collection_object_id;
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL;
                END;
                UPDATE flat 
                SET stale_flag = 0 
                WHERE collection_object_id = r.collection_object_id;
        END LOOP;
---sync keyword index
CTX_DDL.SYNC_INDEX('MCZBASE.FLAT_TEXT_INDEX');
CTX_DDL.SYNC_INDEX('MCZBASE.FLAT_ANY_GEOG');
END;