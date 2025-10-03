
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_PROJECT_AGENT" after INSERT on Project_Agent for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Project_Agent
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Agent_Name R/597 Project_Agent ON CHILD INSERT RESTRICT */
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
        'Cannot INSERT "Project_Agent" because "Agent_Name" does not exist.'
      );
    end if;

    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Project R/170 Project_Agent ON CHILD INSERT RESTRICT */
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
        -20002,
        'Cannot INSERT "Project_Agent" because "Project" does not exist.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;




ALTER TRIGGER "TI_PROJECT_AGENT" ENABLE