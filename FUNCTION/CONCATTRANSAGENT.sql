
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATTRANSAGENT" (
	trans_id IN NUMBER,
	trans_agent_role IN VARCHAR)
RETURN VARCHAR2
AS
	TYPE RC IS REF CURSOR;
	l_str	VARCHAR2(4000);
	l_sep	VARCHAR2(3);
	l_val	VARCHAR2(4000);
	l_cur	RC;
BEGIN
	OPEN l_cur FOR 'SELECT agent_name
		FROM preferred_agent_name, trans_agent
		WHERE trans_agent.agent_id=preferred_agent_name.agent_id
		AND trans_agent.transaction_id = :x
		AND trans_agent.trans_agent_role = :y
		ORDER BY agent_name'
	USING trans_id, trans_agent_role;
	LOOP
		FETCH l_cur INTO l_val;
		EXIT WHEN l_cur%notfound;
		l_str := l_str || l_sep || l_val;
		l_sep := ', ';
	END LOOP;
	CLOSE l_cur;
	RETURN l_str;
END;
 
 