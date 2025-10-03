
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_TRANS_CONTAINER_SQ" 
    BEFORE INSERT ON trans_container
    FOR EACH ROW
    BEGIN
        if :new.trans_container_id is null then
        	select sq_trans_container_id.nextval into :new.trans_container_id from dual;
        end if;
    end;


ALTER TRIGGER "TR_TRANS_CONTAINER_SQ" ENABLE