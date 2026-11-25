
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_INDETERMINATE_AGENT" (
        p_agent_id IN NUMBER
  ) RETURN NUMBER
  IS
        -- INDETERMINATE_MARKER is a magic value -- it MUST match the ctagent_relationship.agent_relationship
        -- controlled vocabulary value used to flag that an agent record is an indeterminate placeholder
        -- potentially referring to one or more specific candidate agents.
        INDETERMINATE_MARKER CONSTANT VARCHAR2(30) := 'potentially referring to';
        v_count NUMBER;
  BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM agent_relations
        WHERE agent_id = p_agent_id
                AND agent_relationship = INDETERMINATE_MARKER;

        IF v_count > 0 THEN
                RETURN 1;
        ELSE
                RETURN 0;
        END IF;
  END is_indeterminate_agent;
