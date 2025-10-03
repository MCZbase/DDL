
  CREATE OR REPLACE EDITIONABLE FUNCTION "IS_PASSWORD_COMPLEX_ENOUGH" 
(
  USERNAME IN VARCHAR2 
, OLDPASSWORD IN VARCHAR2 
, NEWPASSWORD IN VARCHAR2 
) RETURN NUMBER AS 
--  Test password complexity requirements against function used in arctos_user profile.  Only makes
--  the string comparisons to validate if the new password passes the complexity tests, does not 
--  validate that username and oldpassword exist and are correct.
--  @param username the username to test newpassword against, does not need to be an oracle user
--  @param oldpassword an oldpassword string to compare with the newpassword for complexity 
--    requirements testing, is not checked to see if its the actuall password for this user
--  @param newpassword a string to be tested for password complexity requirements.
--  @return 'true' if tests pass raises exception or returns error message if tests fail.
retval varchar2(2000);
BEGIN

retval:='';

if SYS.verify_function_mcz(USERNAME,OLDPASSWORD,NEWPASSWORD) then
  return 'true';
else
  return 'Failed.  No error message.';
end if;

exception
  when others then
   retval:= 'Failed. ' || SQLERRM;
   return retval;
END IS_PASSWORD_COMPLEX_ENOUGH;