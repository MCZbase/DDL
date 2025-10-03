
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_POSITIVE_NUMBER" (inStr varchar2 )
return integer
-- Test to see if a provided varchar value is interpretable as a positive number
--
-- Example of use: 
-- to find all positive numeric attribute values for some field:
-- select attribute_value,is_positive_number(attribute_value)
-- from attributes 
-- where attribute_type='numeric age'
--   and is_postive_number(attribute_value) = 1
--
-- @param inStr a varchar to check
-- @return 1 if inStr can be interpreted as a postive number, otherwise 0
IS
n number;
BEGIN
n := to_number(inStr);
IF n > 0 THEN
    RETURN 1;
ELSE
    RETURN 0;
END IF;
EXCEPTION
WHEN OTHERS THEN
RETURN 0;
END;