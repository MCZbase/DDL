
  CREATE OR REPLACE EDITIONABLE FUNCTION "ISDATE_WITH_FORMAT" 
( p_string in varchar2, format in varchar2)
--  Test to see if a provided varchar is interpretable as a date
--  in a specified format.
--  @param p_string the value to test.
--  @param format the date format (e.g. 'YYYY-MMM-DD') to test against.
--  @return 1 if p_string is intepretable as a date in the specified format, 
--     otherwise 0.
--  @see isdate to test against 'YYYY-MM-DD'.
return integer
as
l_date date;
begin
l_date := to_date(p_string,format);
   return 1;
exception
when others then
return 0;
end;