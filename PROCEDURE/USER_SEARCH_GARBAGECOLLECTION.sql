
  CREATE OR REPLACE EDITIONABLE PROCEDURE "USER_SEARCH_GARBAGECOLLECTION" AUTHID DEFINER AS
    c_retention_days CONSTANT NUMBER      := 7;
    c_batch_size     CONSTANT PLS_INTEGER := 10000;
    -- One cutoff for the whole run; a DATE bind keeps the searchdate index usable
    -- whether that column is DATE or TIMESTAMP.
    v_cutoff     CONSTANT DATE := SYSDATE - c_retention_days;
    v_table      VARCHAR2(300);
    v_rows       NUMBER;
    v_total_rows NUMBER;
    v_failures   PLS_INTEGER := 0;
    v_failed     VARCHAR2(1500);
BEGIN
    DBMS_APPLICATION_INFO.SET_MODULE('USER_SEARCH_GARBAGECOLLECTION', NULL);
    FOR c1_rec IN (
        SELECT t.owner
        FROM dba_tables t
            JOIN all_users u ON u.username = t.owner
        WHERE t.table_name = 'USER_SEARCH_TABLE'
            AND u.oracle_maintained = 'N'
        ORDER BY t.owner
    ) LOOP
        v_total_rows := 0;
        v_table := DBMS_ASSERT.ENQUOTE_NAME(c1_rec.owner, FALSE) || '.USER_SEARCH_TABLE';
        DBMS_APPLICATION_INFO.SET_ACTION(c1_rec.owner);
        -- A failure in one schema is recorded and the loop moves on, so one missing
        -- grant cannot stop cleanup for every other user.
        BEGIN
            LOOP
                EXECUTE IMMEDIATE
                    'DELETE FROM ' || v_table ||
                    ' WHERE searchdate < :cutoff AND ROWNUM <= :batch'
                    USING v_cutoff, c_batch_size;
                v_rows := SQL%ROWCOUNT;
                v_total_rows := v_total_rows + v_rows;
                COMMIT;
                EXIT WHEN v_rows < c_batch_size;
            END LOOP;

            IF v_total_rows > 0 THEN
                DBMS_STATS.GATHER_TABLE_STATS(
                    ownname => c1_rec.owner,
                    tabname => 'USER_SEARCH_TABLE',
                    cascade => TRUE
                );
            END IF;

            DBMS_OUTPUT.PUT_LINE(c1_rec.owner || ': deleted ' || v_total_rows);
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                v_failures := v_failures + 1;
                v_failed := SUBSTR(v_failed || ' ' || c1_rec.owner, 1, 1500);
                DBMS_OUTPUT.PUT_LINE(c1_rec.owner || ': FAILED after deleting ' || v_total_rows || ': ' || SQLERRM);
        END;
    END LOOP;
    DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL);

    -- Fail the job when any schema failed, so the run shows as FAILED.
    IF v_failures > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            v_failures || ' user_search_table cleanup(s) failed:' || v_failed);
    END IF;
END;
