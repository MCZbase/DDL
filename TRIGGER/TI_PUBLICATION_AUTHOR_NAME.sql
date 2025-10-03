
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_PUBLICATION_AUTHOR_NAME" after INSERT on Publication_Author_Name for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Publication_Author_Name
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Agent_Name R/519 Publication_Author_Name ON CHILD INSERT RESTRICT */
    select count(*) into numrows
      from Agent_Name
      where
        /* %JoinFKPK(:%New,Agent_Name," = "," and") */
        :new.Agent_Name_id = Agent_Name.Agent_Name_id;
    if (
      /* %NotnullFK(:%New," is not null and") */

      numrows = 0
    )
    then
      raise_application_error(
        -20002,
        'Cannot INSERT "Publication_Author_Name" because "Agent_Name" does not exist.'
      );
    end if;

    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Publication R/220 Publication_Author_Name ON CHILD INSERT RESTRICT */
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
        -20002,
        'Cannot INSERT "Publication_Author_Name" because "Publication" does not exist.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;




ALTER TRIGGER "TI_PUBLICATION_AUTHOR_NAME" ENABLE