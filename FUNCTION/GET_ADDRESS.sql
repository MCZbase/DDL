
  CREATE OR REPLACE FUNCTION "GET_ADDRESS" (p_key_val IN NUMBER )
--  Given an agent id, return an addresss, preferring correspondence, then shipping, then home.
--  Use?  
    RETURN VARCHAR2
    AS
       fa addr.formatted_addr%TYPE;
       c NUMBER;
    BEGIN
        SELECT COUNT(*) INTO c 
        FROM addr 
        WHERE valid_addr_fg = 1 
        AND addr_type = 'Correspondence' 
        AND agent_id = p_key_val;
        IF c = 1 THEN
            SELECT formatted_addr INTO fa 
            FROM addr 
            WHERE valid_addr_fg = 1 
            AND addr_type = 'Correspondence' 
            AND agent_id = p_key_val;
        ELSE
            SELECT COUNT(*) INTO c FROM addr 
            WHERE valid_addr_fg = 1 
            AND addr_type = 'Shipping' 
            AND agent_id = p_key_val;
            IF c = 1 THEN
                SELECT formatted_addr INTO fa 
	            FROM addr 
	            WHERE valid_addr_fg = 1 
	            AND addr_type='Shipping' 
	            AND agent_id = p_key_val;
	        ELSE
                SELECT COUNT(*) INTO c 
                FROM addr 
                WHERE valid_addr_fg = 1 
                AND addr_type = 'Home' 
                AND agent_id = p_key_val;
                IF c = 1 THEN
                    SELECT formatted_addr INTO fa 
                    FROM addr 
                    WHERE valid_addr_fg = 1 
                    AND addr_type='Home' 
                    AND agent_id = p_key_val;
                END IF;
            END IF;
        END IF;
        RETURN fa;
    END;