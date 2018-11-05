
  CREATE OR REPLACE PROCEDURE "IS_FLAT_STALE" IS 
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
                --dbms_output.put_line(r.collection_object_id);
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
END;