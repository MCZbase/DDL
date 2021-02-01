
  CREATE OR REPLACE FUNCTION "IS_FLUID" 
(
  PRESERVE_METHOD IN VARCHAR2  
) RETURN NUMBER AS 
--  Identify whether or not a string represents a preservation method 
--  that is some form of fluid storage (including frozen and DMSO).
--  Typical pattern is fluid: temperature, e.g. ethanol -40C
--  
--  @param preserve_method to check if a fluid preserve method
--  @return 1 if preserve_method is a fluid method, 0 otherwise.
--  @see MCZBASE.IS_FLUID_STRICT() for a narrower definition of fluid.
BEGIN
  if preserve_method like '%ethanol' then return 1; end if;
  if preserve_method like '%alcohol' then return 1; end if;
  if preserve_method like '%isopropyl' then return 1; end if;
  if preserve_method like '%isopropanol' then return 1; end if;
  if preserve_method like '%formalin%' then return 1; end if;  
  if preserve_method like '%RNAlater' then return 1; end if; 
  if preserve_method like '%DMSO%' then return 1; end if;  
  if preserve_method like '%Frozen%' then return 1; end if;
  if preserve_method like '%frozen%' then return 1; end if;
  if preserve_method like '%glycerol%' then return 1; end if;
  if preserve_method like '%lycerin%' then return 1; end if;
  RETURN 0;
END IS_FLUID;