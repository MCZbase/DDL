
  CREATE OR REPLACE FUNCTION "GETMONTHCOLLECTED" (b IN varchar,e IN varchar)
RETURN varchar
-- Given a pair of strings that are expected to be begin and end dates, 
-- extract the month from the strings, that is, expectation is to 
-- return mm from yyyy-mm-dd,yyyy-mm-dd if the month (mm) of the start 
-- and end dates are the same, and both contain a month,
-- otherwise on a failure return '00', does not check to see if strings
-- actually contain dates, assumes that they do.
-- 
-- @param b the string representing the begin date.
-- @param e the string representing the end date.
-- @return the 6th and 7th characters of b (mm in yyyy-mm-dd), if b and e each
--    contain at least 7 characters and the 6th and 7th characters of b and e 
--    are identical, otherwise, return '00'.  
-- @see getdaycollected
-- @see getyearcollected
-- @see MCZBASE.GET_PRETTY_DATE() uses this function.
AS
    rby varchar(4);
    rey  varchar(4);
   BEGIN
    if length(b) < 7 OR length(e) < 7 then
    return '00';
    end if;
    rby:=substr( b, 6, 2 );
    rey:=substr( e, 6, 2 );
if (rby!=rey) then
return '00';
end if;
return rby;
end;