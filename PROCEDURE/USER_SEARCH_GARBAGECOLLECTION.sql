
  CREATE OR REPLACE EDITIONABLE PROCEDURE "USER_SEARCH_GARBAGECOLLECTION" AS
    v_sql        VARCHAR2(1000);
    v_rows       NUMBER;
    v_total_rows NUMBER;
BEGIN
    FOR c1_rec IN (
        SELECT owner
        FROM dba_tables
        WHERE table_name = 'USER_SEARCH_TABLE'
    ) LOOP

        v_total_rows := 0;

        LOOP
            v_sql :=
                'DELETE FROM ' || c1_rec.owner || '.user_search_table ' ||
                'WHERE ROWID IN ( ' ||
                '  SELECT rid FROM ( ' ||
                '    SELECT ROWID AS rid ' ||
                '    FROM ' || c1_rec.owner || '.user_search_table ' ||
                '    WHERE searchdate < (SYSTIMESTAMP - INTERVAL ''7'' DAY) ' ||
                '      AND ROWNUM <= 10000 ' ||
                '  ) ' ||
                ')';

            EXECUTE IMMEDIATE v_sql;

            v_rows := SQL%ROWCOUNT;
            v_total_rows := v_total_rows + v_rows;

            COMMIT;

            EXIT WHEN v_rows = 0;
        END LOOP;

        DBMS_STATS.GATHER_TABLE_STATS(
            ownname => c1_rec.owner,
            tabname => 'USER_SEARCH_TABLE',
            cascade => TRUE
        );

    END LOOP;
END;
