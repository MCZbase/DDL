
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_ROMAN_MONTHCOLLECTED" 
(
  MONTHval IN VARCHAR2  
) RETURN VARCHAR2 
--  Given a one or two digit number between 1 and 12 (with or without --
--  zero padding), return the roman numeral for the given number.     --
--  Used to convert a numeric month to a roman numeral representation --
--  As is often used in Icthyology and Entomology (e.g. 04 to IV)     --
--  If given any other input, returns a single space                  --
AS 
BEGIN
   if MONTHval = '01' or MONTHval = '1' then return 'I'; end if;
   if MONTHval = '02' or MONTHval = '2' then return 'II'; end if;
   if MONTHval = '03' or MONTHval = '3' then return 'III'; end if;     
   if MONTHval = '04' or MONTHval = '4' then return 'IV'; end if;
   if MONTHval = '05' or MONTHval = '5' then return 'V'; end if;
   if MONTHval = '06' or MONTHval = '6' then return 'VI'; end if;  
   if MONTHval = '07' or MONTHval = '7' then return 'VII'; end if;
   if MONTHval = '08' or MONTHval = '8' then return 'VIII'; end if;
   if MONTHval = '09' or MONTHval = '9' then return 'IX'; end if;  
   if MONTHval = '10' then return 'X'; end if;  
   if MONTHval = '11' then return 'XI'; end if;  
   if MONTHval = '12' then return 'XII'; end if;  
  RETURN ' ';
END GET_ROMAN_MONTHCOLLECTED;
 