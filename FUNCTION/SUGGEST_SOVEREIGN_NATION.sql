
  CREATE OR REPLACE FUNCTION "SUGGEST_SOVEREIGN_NATION" (
	locality_id IN NUMBER)
RETURN VARCHAR2
-- Given a locality ID, return a suggestion for the value of locality.sovereign_nation based on geog_auth_rec.country.
-- Note, will return unknown instead of High Seas for localities in the high seas.
-- @param locality_id to lookup
-- @return '[unknown]' if no match to country was found, or a matching value from ctsovereign_nation
AS
	TYPE RC IS REF CURSOR;
	retval	VARCHAR2(4000);
	l_val	VARCHAR2(4000);   
	l_cur	RC;
BEGIN
	OPEN l_cur FOR '
    select nvl(sn.SOVEREIGN_NATION,''[unknown]'') 
       from locality 
            left join geog_auth_rec on locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id
            left join ctsovereign_nation sn on geog_auth_rec.country = sn.SOVEREIGN_NATION
    where locality_id = :x'
	USING locality_id;
	LOOP
		FETCH l_cur INTO l_val;
		EXIT WHEN l_cur%notfound;
              retval := l_val;
	END LOOP;
	CLOSE l_cur;
    if retval is null then 
       retval := '[unknown]';
    end if;
	RETURN retval;
END;