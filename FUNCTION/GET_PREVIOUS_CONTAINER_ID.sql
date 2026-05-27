
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PREVIOUS_CONTAINER_ID" (
	container_id IN NUMBER)
RETURN number
-- Given a container_id, return the id of the most recent container that that container
-- was placed into in the container history
-- @param container_id to lookup the history for
-- @return a container_id or null 
AS
	TYPE RC IS REF CURSOR;
	retval	number;
	l_sep	VARCHAR2(3);
	l_val	number;
	l_cur	RC;
BEGIN
	OPEN l_cur FOR '
               SELECT
                  container.container_id
                FROM container_history
                  left join container on container_history.parent_container_id = container.container_id
                WHERE
                    container_history.container_id = :x
               ORDER BY install_date DESC NULLS LAST
               fetch first 1 rows only
    '
	USING container_id;
	LOOP
		FETCH l_cur INTO l_val;
		EXIT WHEN l_cur%notfound;
		retval := l_val;
	END LOOP;
	CLOSE l_cur;
	RETURN retval;
END;