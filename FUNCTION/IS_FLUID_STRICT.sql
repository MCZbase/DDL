
  CREATE OR REPLACE FUNCTION "IS_FLUID_STRICT" 
(
  PRESERVE_METHOD IN VARCHAR2  
) RETURN NUMBER AS 
--  Identify whether or not a string represents a preservation method in fluid.
--  Looks to see if the presented preserve method ends with 'ethanol' or another 
--  name of a fluid storage medium (various alcohols plus formalin).
--  Typical pattern is "fluid" or "fluid: temperature", no trailing %
--  prevents matching on frozen storage.
--
--  @param preserve_method to check if a fluid preserve method
--  @return 1 if preserve_method is a fluid method, 0 otherwise.
--  @see MCZBASE.IS_FLUID() for a broader definition of fluid.
BEGIN
  if preserve_method like '%ethanol' then return 1; end if;
  if preserve_method like '%alcohol' then return 1; end if;
  if preserve_method like '%isopropyl' then return 1; end if;
  if preserve_method like '%isopropanol' then return 1; end if;
  if preserve_method like '%formalin' then return 1; end if;
    if preserve_method like '%formalin: neutral buffered' then return 1; end if; 
  RETURN 0;
END IS_FLUID_STRICT;