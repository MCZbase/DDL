
  CREATE OR REPLACE EDITIONABLE FUNCTION "SUGGEST_SOVEREIGN_NATION_V2" (
	locality_id IN NUMBER)
RETURN VARCHAR2
-- Given a locality ID, return a suggestion for the value of locality.sovereign_nation based on geog_auth_rec.country.
-- has attempts to convert several likely matches such as United States to United States of America.
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
    select nvl(mczbase.suggest_sov_nation_from_str(country),''[unknown]'') 
       from locality 
            left join geog_auth_rec on locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id
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
END SUGGEST_SOVEREIGN_NATION_V2;