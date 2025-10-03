
  CREATE OR REPLACE EDITIONABLE FUNCTION "GETDAYCOLLECTED" (b IN varchar,e IN varchar)
RETURN varchar
-- given a pair of strings, assumed to be dates in iso format yyyy-mm-dd, 
-- return the dd portion as a string, if it is the same in both dates, 
-- otherwise return the string '00'. can handle iso date/time strings.
-- note, does not check that these are actually dates, and will return some
-- value with non-date strings.
-- @param b begin date
-- @param e end date
-- @return the dd portion of b if it is the same as the dd portion of e, otherwise '00'
-- @see getmonthcollected
-- @see getyearcollected
-- @see MCZBASE.GET_PRETTY_DATE() uses this function.
AS
    rby varchar(4);
    rey  varchar(4);
BEGIN
    -- note, we aren't actually checking for dates, just the 9th and 10th characters
    -- of a pair of strings of at least length 10, if these two characters are the
    -- same, return them.
    if length(b) < 10 OR length(e) < 10 then
       return '00';
    end if;
    rby:=substr( b, 9, 2 );
    rey:=substr( e, 9, 2 );
    if (rby!=rey) then
       return '00';
    end if;
    return rby;
end;