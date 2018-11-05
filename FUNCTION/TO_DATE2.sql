
  CREATE OR REPLACE FUNCTION "TO_DATE2" (vcDate IN VARCHAR2)
-- May not be in use.  Not found in coldfusion code, has no references.
--
-- Obtain the 4 digit year portion of a string converted to a date.
-- Invokes to_date(vcDate,'YYYY') with error handling.
-- @param vcDate string containing a date
-- @return the 4 digit year portion of the date found in vcDate, or null if any
--   exception was raised in coverting vcDate to a date.
RETURN DATE
IS

dtDate DATE;
BEGIN


-- you could do substring here on vcDate to hide it from the view code

RETURN( TO_DATE(vcDate, 'YYYY' ));

EXCEPTION

WHEN OTHERS

THEN RETURN NULL;


END;