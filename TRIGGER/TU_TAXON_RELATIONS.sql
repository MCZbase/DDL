
  CREATE OR REPLACE TRIGGER "TU_TAXON_RELATIONS" after UPDATE on Taxon_Relations for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Taxon_Relations
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Taxonomy  Taxon_Relations ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Taxonomy
    where
      /* %JoinFKPK(:%New,Taxonomy," = "," and") */
      :new.Related_Taxon_Name_id = Taxonomy.Taxon_Name_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Taxon_Relations" because "Taxonomy" does not exist.'
    );
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Taxonomy  Taxon_Relations ON CHILD UPDATE RESTRICT */
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
      'Cannot UPDATE "Taxon_Relations" because "Taxonomy" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TU_TAXON_RELATIONS" ENABLE