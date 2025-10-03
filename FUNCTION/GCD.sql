
  CREATE OR REPLACE EDITIONABLE FUNCTION "GCD" 
(
  PARAM1 IN number,
  PARAM2 IN number  
) RETURN NUMBER AS 
--- given two numbers, return the greatest common divisor of those two numbers.   
BEGIN
   if PARAM2 = 0 then
      return PARAM1;
   else 
      return MCZBASE.GCD(PARAM2, mod(PARAM1, PARAM2));
   end if;
END GCD;