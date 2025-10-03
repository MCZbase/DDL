
  CREATE OR REPLACE EDITIONABLE PROCEDURE "LIST_AGENT_RELATIONSHIPS" AS


    CURSOR agent_cursor IS
      select AGENT_ID, AGENT_NAME FROM AGENT_NAME WHERE AGENT_NAME_TYPE = 'login';
    
    -- Declare a cursor to find candidate tables and columns
    CURSOR fk_column_cursor IS
    SELECT TABLE_NAME, COLUMN_NAME 
    FROM ALL_CONS_COLUMNS 
    WHERE (
        CONSTRAINT_NAME = 'FK_IDAGENT_AGENT' 
        OR CONSTRAINT_NAME = 'FK_LATLONG_AGENT' 
        OR CONSTRAINT_NAME = 'FK_LATLONG_VERIFIEDBY' 
        OR CONSTRAINT_NAME = 'FK_MEDIARELNS_AGENT' 
        OR CONSTRAINT_NAME = 'FK_TRANS_ENTERED_AGENT_ID' 
        OR CONSTRAINT_NAME = 'FK_DEACC_ITEM_RECONCILED_AGENT'
        OR CONSTRAINT_NAME = 'FK_ENCUMB_AGENT' 
        OR CONSTRAINT_NAME = 'FK_PERMIT_CONTACTAGENT'
        OR CONSTRAINT_NAME = 'FK_SHIPMENT_PACKED_BY' 
        OR CONSTRAINT_NAME = 'FK_COLL_OBJECT_EDITED_AGENT' 
        OR CONSTRAINT_NAME = 'FK_COLL_OBJECT_ENTERED_AGENT'
        OR CONSTRAINT_NAME = 'FK_COLLECTOR_AGENT'
        OR CONSTRAINT_NAME = 'FK_ATTRIBUTES_AGENT'
        OR CONSTRAINT_NAME = 'LOAN_ITEM_FK1' 
        OR CONSTRAINT_NAME = 'FK_DETERMINER_AGENT'
        )
        AND (
        column_Name like '%PERSON%' 
        OR column_name like '%AGENT%' 
        OR column_name like '%DETERMINER%' 
        OR column_name like '%VERIF%'
        )
    AND OWNER = 'MCZBASE'
    ORDER BY TABLE_NAME;
    

    v_agent_id     AGENT_NAME.AGENT_ID%TYPE;
    v_agent_name   VARCHAR2(128);

    v_table_name   VARCHAR2(128);
    v_column_name  VARCHAR2(128);
    v_dynamic_sql  VARCHAR2(1000);
    count_found    NUMBER;
  
BEGIN
      -- Truncate the temporary table at the beginning of the execution logic
    EXECUTE IMMEDIATE 'TRUNCATE TABLE CF_TEMP_AGENT_ROLE_SUMMARY';
    COMMIT;
    FOR emp_rec IN agent_cursor LOOP
        
        v_agent_id := emp_rec.agent_id;
        v_agent_name := emp_rec.agent_name;
        
        FOR col_rec IN fk_column_cursor LOOP

           v_table_name := col_rec.table_name;
           v_column_name := col_rec.column_name;

              v_dynamic_sql := 'SELECT COUNT(*) FROM "' || v_table_name || '" WHERE "' || v_column_name || '" = :eid';
   
               EXECUTE IMMEDIATE v_dynamic_sql INTO count_found USING v_agent_id;   
               
               INSERT INTO CF_TEMP_AGENT_ROLE_SUMMARY (table_name, agent_id, count, column_name, agent_name)
               VALUES (v_table_name, v_agent_id, count_found, v_column_name, v_agent_name);
               
          END LOOP;

        COMMIT;

    END LOOP;

    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
      -- Handle exceptions as necessary
      -- ROLLBACK; -- Consider rolling back if the logic demands it
      RAISE_APPLICATION_ERROR(-20001, 'An error occurred: ' || SQLERRM);
END list_agent_relationships;