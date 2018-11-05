
  CREATE OR REPLACE TRIGGER "TR_MEDIA_RELATIONS_SQ" 
before insert ON media_relations
for each row
begin
    IF :new.media_relations_id IS NULL THEN
        select sq_media_relations_id.nextval
    	into :new.media_relations_id from dual;
    END IF;

    if :NEW.created_by_agent_id is null then
        select agent_name.agent_id
        into :NEW.created_by_agent_id
        from agent_name
        where agent_name_type='login'
        and upper(agent_name.agent_name) = SYS_CONTEXT('USERENV','SESSION_USER');
    end if;
end;

ALTER TRIGGER "TR_MEDIA_RELATIONS_SQ" ENABLE