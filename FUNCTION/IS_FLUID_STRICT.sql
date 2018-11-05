
  CREATE OR REPLACE FUNCTION "IS_FLUID_STRICT" 
(
  PRESERVE_METHOD IN VARCHAR2  
) RETURN NUMBER AS 
BEGIN
  if preserve_method like '%ethanol' then return 1; end if;
  if preserve_method like '%alcohol' then return 1; end if;
  if preserve_method like '%isopropyl' then return 1; end if;
  if preserve_method like '%isopropanol' then return 1; end if;
  if preserve_method like '%formalin' then return 1; end if;
  RETURN 0;
END IS_FLUID_STRICT;