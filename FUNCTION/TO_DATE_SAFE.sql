
  CREATE OR REPLACE EDITIONABLE FUNCTION "TO_DATE_SAFE" (possibleDate IN VARCHAR2)
-- Attempt to convert a string to a date.
-- @param possibleDate string possibly containing a date in the form yyyy-mm-dd, 
--   dd-Mon-yy, or dd Month yyyy
-- @return the date found in possibleDate, or null if any
--   exception was raised in coverting possibleDate to a date.
RETURN DATE
IS
  testDate VARCHAR2(20);
  retval DATE;
BEGIN

   retval := NULL;
   testDate := trim(possibleDate);

   if regexp_like(testDate,'[0-9]{4}-([0][1-9]|[1][0-2])-([0][1-9]|[12][0-9]|[3][0-2])') then
      retval := TO_DATE(testDate, 'YYYY-mm-dd');
   elsif regexp_like(testDate,'[0-9]{2}-[JANFEBMRPYULAGSOCTVD]{3}-[0-9]{2}') then
      retval := TO_DATE(testDate, 'dd-MM-yy');
   elsif regexp_like(testDate,'[0-9]{2} [A-Z][a-z]+ [0-9]{4}') then
      retval := TO_DATE(testDate, 'dd Mm yyyy');
   elsif regexp_like(testDate,'[0-9]{2}/[0-9]{2}/[0-9]{4}') then
      retval := TO_DATE(testDate, 'mm/dd/YYYY');
   end if;   

   return retval;

   EXCEPTION
      WHEN OTHERS
      THEN RETURN NULL;

END;