
  CREATE OR REPLACE EDITIONABLE FUNCTION "TO_ENDDATE" (datestring  in varchar)
return timestamp
--  Given a string test for conformation to the structure of an single or
--  indeterminate ISO date or date time and convert to a timestamp for the
--  end of the date range (e.g. 1880 becomes the timestamp for 1880-12-31).
--  Does not handle date ranges in the form of date/date, or all forms of 
--  valid ISO single dates.  May discard time information in conversion.
--  @param datestring a varchar which may or may not contain a date.
--  @return a timestamp for the end of the date provided
--     or null if the date string is not an ISO date in a recognized form.
as
retval timestamp;
status varchar2(255);
begin
    status:=is_iso8601(datestring);
    IF status != 'valid' THEN
       return null;
    else 
        IF regexp_like(datestring,'^[0-9]{4}$') then
            retval := to_date(datestring||'-12-31','yyyy-mm-dd');
        elsif regexp_like(datestring,'^[0-9]{4}-[0-9]{2}$') then
            retval := last_day(to_date(datestring,'yyyy-mm'));
        elsif regexp_like(datestring,'^[0-9]{4}-[0-9]{2}-[0-9]{2}$') then
            retval := to_date(datestring,'yyyy-mm-dd');
        elsif regexp_like(datestring,'^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}$') then
            retval := to_date(datestring,'yyyy-mm-ddThh');
        elsif regexp_like(datestring,'^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}$') then
            retval := to_date(datestring,'yyyy-mm-dd"T"HH24:mm');
        elsif regexp_like(datestring,'^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}$') then
            retval := to_date(datestring,'yyyy-mm-dd"T"hh:mm:ss');
        elsif regexp_like(datestring,'^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$') then
            retval := to_date(datestring,'yyyy-mm-dd"T"hh:mm:ss"Z"');
        elsif regexp_like(datestring,'^[0-9]{4}-[0-9]{2}-[0-9].*') then
            retval := to_date(substr(datestring,0,10),'yyyy-mm-dd');
        end if;
    end if;
    return retval;
end;