
  CREATE OR REPLACE FUNCTION "GET_SOVEREIGNNATIONCODE" (locality_id in NUMBER )
return varchar2
-- Given a locality id, return the country code for that sovereign nation, or '[unknown]'
-- or 'High Seas', if sovereign nation is null, looks in geog_auth_rec.country.
-- @param locality_id of the locality for which to lookup the sovereign nation.
-- @return varchar2 containing a country code, or string.
as
type rc is ref cursor;
retval varchar2(4000);
sn varchar2(250);
sncode varchar2(5);
co varchar2(250);
cocode varchar2(5);
l_cur rc;
begin

retval := '';

open l_cur for '
select sovereign_nation, mczbase.get_countrycode(sovereign_nation) scode, 
                    geog_auth_rec.country, mczbase.get_countrycode(country) ccode
from locality 
  left join geog_auth_rec on locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id
where locality_id = :x and rownum < 2 
'
using locality_id;

loop
fetch l_cur into sn, sncode, co, cocode;
exit when l_cur%notfound;
  if sn='[unknown]' then 
     retval := sn;
  else if sn =  'High Seas' then
     retval := sn;    
  else if sn = '[antarctic treaty area]' then
    retval := 'AQ';
  else if sncode is not null then
     retval := sncode;      
  else if cocode is not null then
     retval := cocode;      
  else if co is not null then
     retval := co; 
  else 
     retval := '';
  end if;
  end if;
  end if;
  end if;
  end if;
  end if;      
end loop;

close l_cur;

return retval;
end;