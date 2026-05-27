
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PREVIOUS_CONTAINER_LABEL" (
	container_id IN NUMBER)
RETURN varchar
-- Given a container_id, return the label of the most recent container that that container
-- was placed into in the container history
-- @param cotnainer_id to lookup the history for
-- @return a container label or null 
AS
	TYPE RC IS REF CURSOR;
	retval	varchar(255);
	l_sep	VARCHAR2(3);
	l_val	varchar(255);
	l_cur	RC;
BEGIN
    retval := '';
	OPEN l_cur FOR '
               SELECT
                  -- install_date,
                  -- container_type,
                  label
                  --, description,
                  -- barcode,
                  -- container_history.parent_container_id
                FROM container_history
                  left join container on container_history.parent_container_id = container.container_id
                WHERE
                    container_history.container_id = :x
                GROUP BY
                  install_date,
                  container_type,
                  label,
                  description,
                  barcode,
                  container_history.parent_container_id
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