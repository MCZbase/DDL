
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_MEDIA_LABELS_SQ" 
before insert ON media_labels for each row
begin
    IF :new.media_label_id IS NULL THEN
        select sq_media_label_id.nextval
    	into :new.media_label_id from dual;
    END IF;

    if :NEW.assigned_by_agent_id is null then
        select agent_name.agent_id
        into :NEW.assigned_by_agent_id
        from agent_name
        where agent_name_type='login'
        and upper(agent_name.agent_name) = SYS_CONTEXT('USERENV','SESSION_USER');
        select 0 into :NEW.assigned_by_agent_id from dual;
    end if;
end;

ALTER TRIGGER "TR_MEDIA_LABELS_SQ" ENABLE