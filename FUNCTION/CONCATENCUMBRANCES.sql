
  CREATE OR REPLACE FUNCTION "CONCATENCUMBRANCES" (p_key_val  in VARCHAR2 )
return varchar2
-- given a collection object id return a semicolon delimited list of encumbrances
-- for that collection object.
-- @param p_key_val the collection_object_id for which to find encumbrances
-- @return null or a semicolon delimited list of encumbrance actions
as
    type rc is ref cursor;
    l_str    varchar2(4000);
    l_sep    varchar2(30);
    l_val    varchar2(4000);
    l_cur    rc;
begin
    open l_cur for '
        select encumbrance_action
        from encumbrance, coll_object_encumbrance
        where encumbrance.encumbrance_id = coll_object_encumbrance.encumbrance_id
        AND coll_object_encumbrance.collection_object_id  = :x '
    using p_key_val;
    loop
        fetch l_cur into l_val;
        exit when l_cur%notfound;
        l_str := l_str || l_sep || l_val;
        l_sep := '; ';
    end loop;
    close l_cur;

    return l_str;
end;