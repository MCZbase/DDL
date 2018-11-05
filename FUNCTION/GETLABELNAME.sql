
  CREATE OR REPLACE FUNCTION "GETLABELNAME" (collobjid IN number)
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
 
 