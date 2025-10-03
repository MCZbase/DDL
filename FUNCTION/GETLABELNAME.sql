
  CREATE OR REPLACE EDITIONABLE FUNCTION "GETLABELNAME" (collobjid IN number)
-- given a collection_object_id, return the label name of the first collector, or
-- if the first collector has no agent_name of type labels, then the preferred name for that
-- collector.
-- @param collobjid the collection object id for which to lookup the label name of 
--   the first collector.
-- @return the agent_name of type 'labels' or if none for the first collector, the
--   preferred name for that collector, or null if the collection object has no collectors.
-- @see get_agentnameoftype(agent_id, 'labels') 
RETURN varchar2
AS
    n number;
    retval VARCHAR2(100);
BEGIN
    SELECT count(*) INTO n
    FROM collector, agent_name
    WHERE collobjid = collector.collection_object_id
    AND collector.agent_id = agent_name.agent_id
    AND agent_name.agent_name_type = 'labels'
    AND collector.coll_order = 1;
    IF n = 0 THEN
        SELECT agent_name INTO retval
        FROM collector, preferred_agent_name
        WHERE collobjid = collector.collection_object_id
        AND collector.agent_id = preferred_agent_name.agent_id
        AND collector.coll_order = 1;
    ELSE
        SELECT agent_name INTO retval
        FROM collector, agent_name
        WHERE collobjid = collector.collection_object_id
        AND collector.agent_id = agent_name.agent_id
        AND agent_name.agent_name_type = 'labels'
        AND collector.coll_order = 1;
    END IF;
    RETURN retval;
END;