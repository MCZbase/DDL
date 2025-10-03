
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_STORAGE_PARENTAGE" (
	container_id IN NUMBER)
RETURN VARCHAR2
-- Given a container ID, return a concatenated list of parent storage locations for that container up to room for simple printing.
-- @param container_id to lookup
-- @return a colon separated string of container labels from the provided container to room (or campus, if not MCZ-campus)
--    omits labels for container type collection object, builing, and floor.
--    represents material not placed in a campus as having Unplaced as the root parent.
-- @see CONCATLOCATION which only return the labels, not the container types.
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
    where container_type <> ''collection object'' 
         and container_type <> ''institution''
         and container_type <> ''building'' 
         and container_type <> ''floor''
         and label <> ''MCZ-campus'' and container_id <> 1 
         connect by prior parent_container_id = container_id
         start with container_id = :x'
	USING container_id;
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
END;