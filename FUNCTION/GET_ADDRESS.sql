
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_ADDRESS" (p_key_val IN NUMBER )
--  Given an agent id, return an addresss, preferring correspondence, then shipping, then home.
--  Used in getLoanFormInfo.cfm to obtain inside and outside addresses for loans.
--
--  @param p_key_val the agent_id for which to look up the address
--  @return a formatted addres of type corresponcence, shipping, home, or null if no 
--     address is found for the provided agent_id.
    RETURN VARCHAR2
    AS
       fa addr.formatted_addr%TYPE;
       c NUMBER;
    BEGIN
        SELECT COUNT(*) INTO c 
        FROM addr 
        WHERE valid_addr_fg = 1 
        AND addr_type = 'correspondence' 
        AND agent_id = p_key_val;
        IF c = 1 THEN
            SELECT formatted_addr INTO fa 
            FROM addr 
            WHERE valid_addr_fg = 1 
            AND addr_type = 'correspondence' 
            AND agent_id = p_key_val;
        ELSE
            SELECT COUNT(*) INTO c FROM addr 
            WHERE valid_addr_fg = 1 
            AND addr_type = 'shipping' 
            AND agent_id = p_key_val;
            IF c = 1 THEN
                SELECT formatted_addr INTO fa 
	            FROM addr 
	            WHERE valid_addr_fg = 1 
	            AND addr_type='shipping' 
	            AND agent_id = p_key_val;
	        ELSE
                SELECT COUNT(*) INTO c 
                FROM addr 
                WHERE valid_addr_fg = 1 
                AND addr_type = 'home' 
                AND agent_id = p_key_val;
                IF c = 1 THEN
                    SELECT formatted_addr INTO fa 
                    FROM addr 
                    WHERE valid_addr_fg = 1 
                    AND addr_type='home' 
                    AND agent_id = p_key_val;
                END IF;
            END IF;
        END IF;
        RETURN fa;
    END;