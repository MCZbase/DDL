
  CREATE OR REPLACE EDITIONABLE FUNCTION "SUGGEST_SOV_NATION_FROM_STR" (
	country IN varchar2)
RETURN VARCHAR2
-- Given a name of a country, return a suggestion for the value of locality.sovereign_nation based 
-- on a lookup in ctsovereign_nation, with some mapping of likely variants such as
-- United States of America for United States.
-- 
-- @param country string for which to lookup a sovereign nation value
-- @return '[unknown]' if no match to country was found, or a matching value from ctsovereign_nation
AS
	TYPE RC IS REF CURSOR;
	retval	VARCHAR2(4000);
    tocheck	VARCHAR2(4000);
	l_val	VARCHAR2(4000);   
	l_cur	RC;
BEGIN
    -- fallback value if no matches are found
    retval := '[unknown]';
    tocheck := country;

    -- do some likely value replacements
    if country = 'Bolivia' then 
       tocheck := 'Bolivia, Plurinational State of';
    end if;     
    if country = 'Trinidad' then 
       tocheck := 'Trinidad and Tobago';
    end if;           
    if country = 'Taiwan' then 
       tocheck := 'Taiwan, Province of China [disputed]';
    end if;  
    if country = 'Tanzania' then 
       tocheck := 'Tanzania, United Republic of';
    end if;       
    if country = 'South Georgia and Sandwich Islands' then 
       tocheck := 'United Kingdom of Great Britain and Northern Ireland';
    end if;
    if country = 'Cayman Islands' then 
       tocheck := 'United Kingdom of Great Britain and Northern Ireland';
    end if;   
     if country = 'Iran' then 
       tocheck := 'Iran, Islamic Republic of';
    end if;   
    if country = 'North Korea' then 
       tocheck := 'Korea, Democratic People''s Republic of';
    end if;      
     if country = 'South Korea' then 
       tocheck := 'Korea, Republic of';
    end if;  
    if country = 'Moldova' then 
       tocheck := 'Moldova, Republic of';
    end if;  
    if country = 'Micronesia' then 
       tocheck := 'Federated States of Micronesia';
    end if;  
    if country = 'Netherlands Antilles' then 
       tocheck := 'Netherlands';
    end if;
    if country = 'Venezuela' then 
       tocheck := 'Venezuela, Bolivarian Republic of';
    end if;     
    if country = 'United States' then 
       tocheck := 'United States of America';
    end if;
    if country = 'United States Virgin Islands' then 
       tocheck := 'United States of America';
    end if;   
    if country = 'Virgin Islands of the United States' then 
       tocheck := 'United States of America';
    end if; 
    if country = 'Western Sahara' then 
       tocheck := 'Western Sahara [disputed]';
    end if;  

    -- look up in ctsovereign_nation
	OPEN l_cur FOR '
       select SOVEREIGN_NATION 
       from ctsovereign_nation
       where sovereign_nation = :x'
	USING tocheck;
	LOOP
		FETCH l_cur INTO l_val;
		EXIT WHEN l_cur%notfound;
              retval := l_val;
	END LOOP;
	CLOSE l_cur;

	RETURN retval;
END;