
  CREATE OR REPLACE TRIGGER "UP_INS_AGENT_NAME" after UPDATE or INSERT on agent_name for each row
-- now that we have the data they're updating in the temp table,
declare numrows INTEGER;
begin
select count(*) into numrows
      from agent_name_pending_delete
      where
        agent_name_type='preferred' ;
    if (numrows > 1)
    then
      raise_application_error(
        -20001,
        'You may have only one preferred agent name.'
      );

    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;

ALTER TRIGGER "UP_INS_AGENT_NAME" ENABLE