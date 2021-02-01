
  CREATE OR REPLACE FUNCTION "GET_STORAGE_PARENTATRANK" (
	container_id IN NUMBER,
    storagerank in varchar
    )
RETURN VARCHAR2
-- Given a container ID, return the storage location for that container at the desired rank in the herarchy.
-- @param container_id to lookup
-- @param storagerank the rank in the storage heirarchy to return
-- @return a container label from the provided container for the desired rank
--    represents material not placed in a container at the specified rank as 'Unplaced'.
AS
	TYPE RC IS REF CURSOR;
	l_str	VARCHAR2(4000);
	l_sep	VARCHAR2(3);
	l_val	VARCHAR2(4000);
	l_type	VARCHAR2(4000);    
	l_cur	RC;
BEGIN
	OPEN l_cur FOR '
    select decode(parent_container_id,1, label||'': Unplaced'', label) label,
           decode(container_type,''campus'','''',container_type) container_type from container 
    where container_type <> ''collection object'' and container_type = :x
         and label <> ''MCZ-campus'' and container_id <> 1 
         connect by prior parent_container_id = container_id
         start with container_id = :y'
	USING storagerank, container_id;
	LOOP
		FETCH l_cur INTO l_val, l_type;
		EXIT WHEN l_cur%notfound;
           if l_val = 'Deaccessioned' or l_type is null then 
              l_str := l_str || l_sep || l_val;
           else 
		      l_str := l_str || l_sep || l_val || ' (' || l_type || ')';
           end if;
		l_sep := ': ';
	END LOOP;
	CLOSE l_cur;
    if l_str is null then 
       l_str := 'Unplaced';
    else 
       l_str := replace(l_str,'CFS-campus: Unplaced','CFS-campus');
    end if;
	RETURN l_str;
END GET_STORAGE_PARENTATRANK;