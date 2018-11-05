
  CREATE OR REPLACE FUNCTION "GET_COUNTRYCODE" (COUNTRY in VARCHAR )
return varchar2
-- Given a country name, return the country code for that country name, if any.
-- @param country the country name to look up
-- @return varchar2 containing a country code, or null if an exact match was not found.
as
type rc is ref cursor;
l_str varchar2(4000);
l_val varchar2(4000);

l_cur rc;
begin
l_str := '';
open l_cur for 'select code from ctcountry_code where country  = :x  and rownum < 2'
using country;

loop
fetch l_cur into l_val;
exit when l_cur%notfound;
l_str := l_val;
end loop;
close l_cur;

return l_str;
end;