
  CREATE OR REPLACE TRIGGER "TR_SUBSAMPLEDBY_VALUE" 
     BEFORE INSERT ON specimen_part_attribute
     FOR EACH ROW

DECLARE
    thisError varchar2(4000);
    subsampbyname agent_name.agent_name%type;


BEGIN
/*    if :new.ATTRIBUTE_TYPE='subsampled by' then
        if :new.determined_by_agent_id is null then
            thisError :=  thisError || 'determined by agent is required for subsampled by';
        else
            select agent_name into subsampbyname from preferred_agent_name where agent_id = :new.determined_by_agent_id;
            :new.attribute_value := subsampbyname;
        end if;            
    end if;

  if thisError is not null then
    raise_application_error(
    -20001,
    thisError);
  end if;*/
NULL;
end;
ALTER TRIGGER "TR_SUBSAMPLEDBY_VALUE" ENABLE