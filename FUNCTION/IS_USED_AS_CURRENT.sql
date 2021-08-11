
  CREATE OR REPLACE FUNCTION "IS_USED_AS_CURRENT" 
(
  taxonnameid IN NUMBER 
) RETURN NUMBER AS

cnt number;
--  Check to see if a scientific name is in use as a current id for any specimens
--  @param taxonnameid the taxon_name_id to check for current use.
--  @return 1 if the specified taxon_name_id is used in an identification as
--    the current identification.
BEGIN

select count(*) into cnt from identification_taxonomy it, identification i
where i.ACCEPTED_ID_FG = 1
and i.identification_id = it.identification_id
and taxon_name_id = taxonnameid;

if cnt > 0 then 
    return 1;
else
    return 0;
end if;

END IS_used_as_current;