
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PART_STORAGE_PARENTS" (
    part_collection_object_id IN NUMBER)
RETURN VARCHAR2
-- Given a part collection_object_id, return a concatenated list of parent storage locations for that part up to 
-- room for simple printing.
-- @param collection_object_id for the part to lookup containers
-- @return a colon-separated string of container labels without types from the provided container to room (or campus, if not MCZ-campus)
--    omits labels for container type collection object, building, and floor.
--    represents material not placed in a campus as having Unplaced as the root parent.
AS
    TYPE RC IS REF CURSOR;
    l_str        VARCHAR2(4000);
    l_sep        VARCHAR2(3);
    l_val        VARCHAR2(4000);
    l_prev_val   VARCHAR2(4000);
    l_type       VARCHAR2(4000); 
    l_starting_id NUMBER; -- Variable to store the starting container_id
    l_cur        RC;
    l_first_iteration BOOLEAN := TRUE; -- Track the first iteration
BEGIN
    -- Fetch the starting container ID
    SELECT container_id
    INTO l_starting_id
    FROM coll_obj_cont_hist
    WHERE collection_object_id = part_collection_object_id
          AND current_container_fg = 1;

    -- Open the cursor for the hierarchy query
    OPEN l_cur FOR '
        SELECT decode(parent_container_id, 1, label || '': Unplaced'', label) label,
               decode(container_type, ''campus'', '''', container_type) container_type 
        FROM container
        WHERE container_type <> ''collection object'' 
              AND container_type <> ''institution''
              AND container_type <> ''building'' 
              AND container_type <> ''floor''
              AND label <> ''MCZ-campus'' 
              AND container.container_id <> 1 
        CONNECT BY PRIOR parent_container_id = container.container_id
        START WITH container.container_id = :x'
    USING l_starting_id;

    -- Initialize variables
    l_prev_val := '';
    l_sep := ': ';
    l_str := '';

    -- Loop through the cursor
    LOOP
        FETCH l_cur INTO l_val, l_type;
        EXIT WHEN l_cur % NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Processing Label: ' || l_val);

        -- Handle the first iteration: directly set l_str
        IF l_first_iteration THEN
            l_str := l_val;
            l_first_iteration := FALSE;
            DBMS_OUTPUT.PUT_LINE('First Label Added: ' || l_val);
        ELSE
            -- Skip l_val if it is a redundant substring of l_prev_val
            IF INSTR(l_prev_val, l_val) = 0 THEN
                l_str := l_str || l_sep || l_val;
                DBMS_OUTPUT.PUT_LINE('Label Added: ' || l_val);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Skipped Label: ' || l_val);
            END IF;
        END IF;

        -- Update l_prev_val
        l_prev_val := l_val;
    END LOOP;
    CLOSE l_cur;

    -- Clean up leading ': ' if present
    IF l_str LIKE ': %' THEN
        l_str := LTRIM(l_str, ': ');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Final String: ' || l_str);

    -- Handle edge cases for final output
    IF l_str IS NULL THEN 
        l_str := 'Unplaced';
    ELSE 
        l_str := REPLACE(l_str, 'CFS-campus: Unplaced', 'CFS-campus');
    END IF;

    RETURN l_str;
END;