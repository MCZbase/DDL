
  CREATE OR REPLACE TRIGGER "TRG_BEF_AGENT_RANK" 
 before insert OR UPDATE ON agent_rank
 for each row
    begin
    if :NEW.agent_rank_id is null then
    select sq_agent_rank_id.nextval into :new.agent_rank_id from dual;
    end if;
    IF :new.agent_rank = 'unsatisfactory' AND length(:NEW.remark) < 20 THEN
        raise_application_error(
                -20001,
                'You must leave a >20 character comment for unsatisfactory rankings.'
              );
    END IF;
    end;

ALTER TRIGGER "TRG_BEF_AGENT_RANK" ENABLE