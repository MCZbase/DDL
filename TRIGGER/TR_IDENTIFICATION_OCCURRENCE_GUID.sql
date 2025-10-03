
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_IDENTIFICATION_OCCURRENCE_GUID" 
FOR INSERT OR UPDATE ON MCZBASE.IDENTIFICATION
COMPOUND TRIGGER
-- check if the identification creates a new occurrence on a mixed collection.
-- if so add an occurrenceID entry to guid_our_thing

    -- Create a collection to hold affected collection_object_ids
    TYPE t_id_tab IS TABLE OF MCZBASE.IDENTIFICATION.COLLECTION_OBJECT_ID%TYPE INDEX BY PLS_INTEGER;
    v_ids t_id_tab;
    v_exists NUMBER;

    -- Row-level section: collect the affected IDs
    AFTER EACH ROW IS
    BEGIN
        -- Only collect if COLL_OBJECT_TYPE = 'SP'
        DECLARE
            v_coll_obj_type MCZBASE.COLL_OBJECT.COLL_OBJECT_TYPE%TYPE;
        BEGIN
            SELECT COLL_OBJECT_TYPE INTO v_coll_obj_type
            FROM MCZBASE.COLL_OBJECT
            WHERE COLLECTION_OBJECT_ID = :NEW.COLLECTION_OBJECT_ID;

            IF v_coll_obj_type = 'SP' THEN
                v_ids(v_ids.COUNT + 1) := :NEW.COLLECTION_OBJECT_ID;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
    END AFTER EACH ROW;

    -- After statement section: process collected IDs
    AFTER STATEMENT IS
    BEGIN
        IF v_ids.COUNT > 0 THEN
            FOR i IN 1 .. v_ids.COUNT LOOP
                -- Only insert GUID if this is the sole identification for this collection_object_id
                SELECT COUNT(*) INTO v_exists
                FROM MCZBASE.IDENTIFICATION
                WHERE COLLECTION_OBJECT_ID = v_ids(i);

                IF v_exists = 1 THEN
                    -- Check if a guid already exists for this collection_object_id to avoid duplicates
                    SELECT COUNT(*) INTO v_exists
                    FROM MCZBASE.GUID_OUR_THING
                    WHERE CO_COLLECTION_OBJECT_ID = v_ids(i);

                    IF v_exists = 0 THEN
                        INSERT INTO MCZBASE.GUID_OUR_THING (
                            CO_COLLECTION_OBJECT_ID,
                            TARGET_TABLE,
                            GUID_IS_A,
                            SCHEME,
                            TYPE,
                            LOCAL_IDENTIFIER
                        ) VALUES (
                            v_ids(i),
                            'COLL_OBJECT',
                            'occurrenceID',
                            'urn',
                            'uuid',
                            uuid_v4
                        );
                    END IF;
                END IF;
            END LOOP;
        END IF;
    END AFTER STATEMENT;

END TR_IDENTIFICATION_OCCURRENCE_GUID;


ALTER TRIGGER "TR_IDENTIFICATION_OCCURRENCE_GUID" ENABLE