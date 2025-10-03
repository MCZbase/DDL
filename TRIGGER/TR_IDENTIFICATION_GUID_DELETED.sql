
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_IDENTIFICATION_GUID_DELETED" 
FOR DELETE ON MCZBASE.IDENTIFICATION
COMPOUND TRIGGER
    -- if the identification being deleted is the only identification on a specimen part
    -- that makes that specimen part into an occurrence, mark the occurrenceID record
    -- as deleted

    -- Local PL/SQL collection to hold affected collection_object_ids
    TYPE t_id_tab IS TABLE OF MCZBASE.IDENTIFICATION.COLLECTION_OBJECT_ID%TYPE INDEX BY PLS_INTEGER;
    v_ids t_id_tab;

    -- Row-level section: collect the affected IDs if COLL_OBJECT_TYPE = 'SP'
    AFTER EACH ROW IS
        -- local variable for COLL_OBJECT_TYPE
        v_coll_obj_type MCZBASE.COLL_OBJECT.COLL_OBJECT_TYPE%TYPE;
    BEGIN
        BEGIN
            SELECT COLL_OBJECT_TYPE INTO v_coll_obj_type
            FROM MCZBASE.COLL_OBJECT
            WHERE COLLECTION_OBJECT_ID = :OLD.COLLECTION_OBJECT_ID;

            IF v_coll_obj_type = 'SP' THEN
                v_ids(v_ids.COUNT + 1) := :OLD.COLLECTION_OBJECT_ID;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
    END AFTER EACH ROW;

    -- After statement section: process the collected IDs
    AFTER STATEMENT IS
        v_num_ident NUMBER;
    BEGIN
        IF v_ids.COUNT > 0 THEN
            FOR i IN 1 .. v_ids.COUNT LOOP
                -- Check if there are no more identifications for this collection_object_id
                SELECT COUNT(*) INTO v_num_ident
                FROM MCZBASE.IDENTIFICATION
                WHERE COLLECTION_OBJECT_ID = v_ids(i);

                IF v_num_ident = 0 THEN
                    -- Update GUID_OUR_THING disposition to 'deleted'
                    UPDATE MCZBASE.GUID_OUR_THING
                    SET DISPOSITION = 'deleted',
                        LAST_MODIFIED = CURRENT_DATE
                    WHERE TARGET_TABLE = 'COLL_OBJECT'
                      AND CO_COLLECTION_OBJECT_ID = v_ids(i)
                      AND GUID_IS_A = 'occurrenceID';
                END IF;
            END LOOP;
        END IF;
    END AFTER STATEMENT;

END TR_IDENTIFICATION_GUID_DELETED;


ALTER TRIGGER "TR_IDENTIFICATION_GUID_DELETED" ENABLE