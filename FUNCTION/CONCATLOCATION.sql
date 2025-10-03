
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATLOCATION" (
	container_id IN NUMBER)
RETURN VARCHAR2
-- Given a container ID, return a colon delimited concatenated list of parent storage locations for that container.
-- @param container_id to lookup
-- @return a colon separated string of container labels from the provided container to the root of the tree.
-- @see GET_STORAGE_PARENTAGE which includes the storage location types (building, room, cabinet, etc in the result).
AS
	TYPE RC IS REF CURSOR;
	l_str	VARCHAR2(4000);
	l_sep	VARCHAR2(3);
	l_val	VARCHAR2(4000);
	l_cur	RC;
BEGIN
	OPEN l_cur FOR 'select label from container 
 connect by prior parent_container_id = container_id
 start with container_id = :x'
	USING container_id;
	LOOP
		FETCH l_cur INTO l_val;
		EXIT WHEN l_cur%notfound;
		l_str := l_str || l_sep || l_val;
		l_sep := ': ';
	END LOOP;
	CLOSE l_cur;
	RETURN l_str;
END;