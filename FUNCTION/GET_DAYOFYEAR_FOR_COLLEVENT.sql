
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_DAYOFYEAR_FOR_COLLEVENT" ( collecting_event_id in NUMBER, startend in varchar2 )
return number
-- Function to startdayofyear or enddayofyear for a collecting_event based first on values
-- in start/end day of year fields, then on date_began_date or date_ended_date.
-- @param collecting_event_id the collecting_event_id of the collecting event to lookup
-- @param startend start for startdayofyear, end for enddayofyear
-- @return the specified start or end day of year for the collecting event
--    from the specified collecting event.
as 
   type rc is ref cursor;
   retval number;
   returnvalue number;
   begandate date;
   enddate date;
   originalstartdayofyear number;
   datelen number;
   originalenddayofyear number;
   cur rc;
begin
   retval := null;
   if lower(startend) = 'start' then
        open cur for '
          select nvl(startdayofyear, to_char(date_began_date,''DDD'')) returnvalue,
             date_began_date,
             length(began_date) datelen,
             startdayofyear originalstartdayofyear
          from collecting_event
          where collecting_event_id = :x
        ' using collecting_event_id;
        loop
          fetch cur into returnvalue, begandate, datelen, originalstartdayofyear;
          exit when cur%notfound;
            -- there is a day specified, and the start date has a precision to one day.
            if returnvalue is not null and returnvalue > 0 AND datelen = 10 then
                -- leave out for 1700 start date boundary
                if originalstartdayofyear is not null or begandate > to_date('1700-01-01','yyyy-mm-dd') then
                    -- if startdayofyear is not null, use it, 
                    -- otherwise if began date is not 1700-01-01, then use it.
                    retval := returnvalue;
                end if;
            end if;
        end loop;   
        close cur;   
   else 
        open cur for '
          select nvl(enddayofyear, to_char(date_ended_date,''DDD'')) returnvalue,
             date_ended_date,
             length(ended_date) datelen,
             enddayofyear originalenddayofyear
          from collecting_event
          where collecting_event_id = :x
        ' using collecting_event_id;
        loop
          fetch cur into returnvalue, enddate, datelen, originalenddayofyear;
         exit when cur%notfound;
            -- there is a day specfied and the end date has a precision to one day
            if returnvalue is not null and returnvalue > 0 AND datelen = 10 then
                -- leave out 2100 end date boundary
                if originalenddayofyear is not null or enddate < to_date('2099-01-01','yyyy-mm-dd') then 
                   retval := returnvalue;
                end if;
            end if;
        end loop;   
        close cur;   
   end if;

   return retval;
end;