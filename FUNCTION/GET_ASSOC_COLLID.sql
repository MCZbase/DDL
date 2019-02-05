
  CREATE OR REPLACE FUNCTION "GET_ASSOC_COLLID" (collobjid IN number )
    return varchar2
--  Given a collection_object_id, find the collection id for any attributes of the type
--  Associated MCZ Collection.  
--
-- @param collobjid the collection_object_id to look up.
-- @returns a collection_id, or 'undefinable' when TOO_MANY_ROWS, or null if none.
    as
        l_num number(10);
	begin
	execute immediate 'select c.collection_id collid
  from collection c, (select * from ATTRIBUTES where attribute_type = ''Associated MCZ Collection'') a
		where a.attribute_value(+) = c.collection AND
		a.collection_object_id = ' || collobjid into l_num;
	return l_num;
	EXCEPTION
	when TOO_MANY_ROWS then
		l_num := 'undefinable';
		return  l_num;
	when NO_DATA_FOUND then
		l_num := null;
		return  l_num;
	when others then
		l_num := 'error!';
		return  trim(l_num);
  end;
  --create public synonym get_taxonomy for GET_ASSOC_COLLID;
  --grant execute on GET_ASSOC_COLLID to PUBLIC;