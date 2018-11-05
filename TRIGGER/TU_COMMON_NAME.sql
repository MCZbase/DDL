
  CREATE OR REPLACE TRIGGER "TU_COMMON_NAME" after UPDATE on Common_Name for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Common_Name
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Taxonomy R/512 Common_Name ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Taxonomy
    where
      /* %JoinFKPK(:%New,Taxonomy," = "," and") */
      :new.Taxon_Name_id = Taxonomy.Taxon_Name_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Common_Name" because "Taxonomy" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;

ALTER TRIGGER "TU_COMMON_NAME" ENABLE