
  CREATE OR REPLACE EDITIONABLE FUNCTION "ISDATE" 
( p_string in varchar2)
--  Test to see if a provided varchar is interpretable as a date
--  in the form YYYY-MM-DD.
--  @param p_string the value to test.
--  @return 1 if p_string is intepretable as a YYYY-MM-DD date, otherwise 0
--  @see isdate_with_format to test against an aribtrary date format string.
return integer
as
l_date date;
begin
l_date := to_date(p_string,'YYYY-MM-DD');
   return 1;
exception
when others then
return 0;
end;