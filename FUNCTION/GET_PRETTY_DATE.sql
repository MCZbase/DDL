
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PRETTY_DATE" 
(
  VERBATIM_DATE IN VARCHAR2  
, DATE_BEGAN IN VARCHAR2  
, DATE_ENDED IN VARCHAR2  
, ORDERISO IN NUMBER  
, ROMANMONTH IN NUMBER  
) RETURN VARCHAR2 
--  Given a start date and an end date, and a verbatim date, return a pretty  --
--  formatted date for printing, as a single date if start and end are the    --
--  same, a range if they differ.  Uses dd-mm-yyyy order if orderiso = 0,     --
--  otherwise uses yyyy-mm-dd.  Uses numeric month if romanmonth = 0,         --
--  otherwise uses roman numerals for month.  Returns '[date unknown]'  if    --
--  start is 1700-01-01.   Date_began and Date_ended are in format expected   --
--  by get[year|month|day]collected functions.                                --
AS 
  retval varchar(50);
BEGIN
   retval := '';
   if verbatim_date = '[date unknown]' or date_began = '1700-01-01'  then
      retval := '[date unknown]';
   else 
      if date_began = date_ended then 
         if orderiso = 0 then 
            if romanmonth = 0 then 
               retval := mczbase.getdaycollected(date_began,date_began) || '-' || getmonthcollected(date_began,date_began) || '-' || getyearcollected(date_began,date_began);
            else 
              retval := getdaycollected(date_began,date_began) || '-' || MCZBASE.GET_ROMAN_MONTHCOLLECTED(getmonthcollected(date_began,date_began)) || '-' || getyearcollected(date_began,date_began);         
            end if;
         else 
            if romanmonth = 0 then 
               retval := getyearcollected(date_began,date_began) || '-' || getmonthcollected(date_began,date_began) || '-' || getdaycollected(date_began,date_began);
            else 
              retval := getyearcollected(date_began,date_began) || '-' || MCZBASE.GET_ROMAN_MONTHCOLLECTED(getmonthcollected(date_began,date_began)) || '-' || getdaycollected(date_began,date_began);         
            end if;  
         end if;
      else
         if orderiso = 0 then       
            if romanmonth = 0 then 
               retval := getdaycollected(date_began,date_began) || '-' || getmonthcollected(date_began,date_began) || '-' || getyearcollected(date_began,date_began) ||
                         ' to ' ||  getdaycollected(date_ended,date_ended) || '-' || getmonthcollected(date_ended,date_ended) || '-' || getyearcollected(date_ended,date_ended);
            else 
              retval := getdaycollected(date_began,date_began) || '-' || MCZBASE.GET_ROMAN_MONTHCOLLECTED(getmonthcollected(date_began,date_began)) || '-' || getyearcollected(date_began,date_began) ||
                        ' to ' ||  getdaycollected(date_ended,date_ended) || '-' || MCZBASE.GET_ROMAN_MONTHCOLLECTED(getmonthcollected(date_ended,date_ended)) || '-' || getyearcollected(date_ended,date_ended);
            end if;
         else 
            if romanmonth = 0 then 
               retval := getyearcollected(date_began,date_began) || '-' || getmonthcollected(date_began,date_began) || '-' || getdaycollected(date_began,date_began) ||
                         '/' || getyearcollected(date_ended,date_ended) || '-' || getmonthcollected(date_ended,date_ended) || '-' || getdaycollected(date_ended,date_ended);
            else 
              retval := getyearcollected(date_began,date_began) || '-' || MCZBASE.GET_ROMAN_MONTHCOLLECTED(getmonthcollected(date_began,date_began)) || '-' || getdaycollected(date_began,date_began) ||
                        ' to ' || getyearcollected(date_ended,date_ended) || '-' || MCZBASE.GET_ROMAN_MONTHCOLLECTED(getmonthcollected(date_ended,date_ended)) || '-' || getdaycollected(date_ended,date_ended);
            end if; 
        end if ;
      end if;
   end if;
  RETURN retval;
END GET_PRETTY_DATE;
 