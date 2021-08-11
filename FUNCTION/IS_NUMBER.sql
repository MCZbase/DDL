
  CREATE OR REPLACE FUNCTION "IS_NUMBER" (inStr varchar2 )
return integer
-- Test to see if a provided string is a number.
--
-- Example of use: 
-- to find all non-numeric attribute values of some type:
-- select attribute_value,is_number(attribute_value) 
-- from attributes 
-- where attribute_type='numeric age'
--   and is_number(attribute_value) = 0
--
-- @param inStr string to check.
-- @return 1 if provided string is a number, otherwise 0.

IS
n number;
BEGIN
n := to_number(inStr);
RETURN 1;
EXCEPTION
WHEN OTHERS THEN
RETURN 0;
END;