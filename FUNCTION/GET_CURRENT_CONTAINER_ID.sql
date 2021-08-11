
  CREATE OR REPLACE FUNCTION "GET_CURRENT_CONTAINER_ID" (
	collection_object_id IN NUMBER)
RETURN NUMBER
-- Given a collection_object_id for a part, return the current container ID for the 
-- container for that part. 
-- @param collection_object_id to lookup the container for
-- @return container_id 
AS
	TYPE RC IS REF CURSOR;
	retval	number;
	l_sep	VARCHAR2(3);
	l_val	number;
	l_cur	RC;
BEGIN
	OPEN l_cur FOR '
       select container_id 
       from coll_obj_cont_hist
       where collection_object_id = :x
          and current_container_fg = 1'
	USING collection_object_id;
	LOOP
		FETCH l_cur INTO l_val;
		EXIT WHEN l_cur%notfound;
		retval := l_val;
	END LOOP;
	CLOSE l_cur;
	RETURN retval;
END;