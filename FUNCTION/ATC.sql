
  CREATE OR REPLACE FUNCTION "ATC" 
(cSearchExpression nvarchar2, cExpressionSearched  nvarchar2, nOccurrence smallint  default 1)
-- @depricated does not appear to be used anywhere.
--
-- When performance is an issue:
-- use  nvl(instr(lower(cExpressionSearched), lower(cSearchExpression), 1, nOccurrence),0)   rather than this function.
-- Author:  Igor Nikiforov,  Montreal,  EMail: udfs@sympatico.ca
-- ATC() User-Defined Function
-- Returns the beginning numeric position of the first occurrence of a character expression within another character expression, counting from the leftmost character.
-- The search performed by ATC() is case-insensitive (including  overlaps).
-- ATC(cSearchExpression, cExpressionSearched [, nOccurrence]) Return Values smallint
-- Parameters
-- cSearchExpression nvarchar2(4000) Specifies the character expression that ATC()  searches for in cExpressionSearched.
-- cExpressionSearched nvarchar2(4000) Specifies the character expression cSearchExpression searches for.
-- nOccurrence smallint Specifies which occurrence (first, second, third, and so on) of cSearchExpression is searched for in cExpressionSearched. By default, ATC() searches for the first occurrence of cSearchExpression (nOccurrence = 1). Including nOccurrence lets you search for additional occurrences of cSearchExpression in cExpressionSearched.
-- ATC()  returns 0 if nOccurrence is greater than the number of times cSearchExpression occurs in cExpressionSearched.
-- Remarks
-- ATC() searches the second character expression for the first occurrence of the first character expression,
-- without concern for the case (upper or lower) of the characters in either expression. Use AT()  to perform a case-sensitive search.
-- It then returns an integer indicating the position of the first character in the character expression found. If the character expression is not found, ATC() returns 0.
-- ATC is nearly similar to a function Oracle PL/SQL INSTR
-- Example
-- select ATC('IS', 'Now is the time for all good men')  from sys.dual;  -- Displays 5, case-insensitive
-- See Also RAT(), AT2()  User-Defined Function
return smallint
deterministic
as
begin
     return nvl(instr(lower(cExpressionSearched), lower(cSearchExpression), 1, nOccurrence),0);
end ATC;