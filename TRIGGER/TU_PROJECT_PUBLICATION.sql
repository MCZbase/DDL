
  CREATE OR REPLACE TRIGGER "TU_PROJECT_PUBLICATION" after UPDATE on Project_Publication for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Project_Publication
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Publication R/596 Project_Publication ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Publication
    where
      /* %JoinFKPK(:%New,Publication," = "," and") */
      :new.Publication_id = Publication.Publication_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Project_Publication" because "Publication" does not exist.'
    );
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Project R/595 Project_Publication ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Project
    where
      /* %JoinFKPK(:%New,Project," = "," and") */
      :new.Project_id = Project.Project_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Project_Publication" because "Project" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TU_PROJECT_PUBLICATION" ENABLE