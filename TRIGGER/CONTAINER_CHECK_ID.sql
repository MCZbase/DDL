
  CREATE OR REPLACE TRIGGER "CONTAINER_CHECK_ID" 
before insert ON container_check 
for each row 
begin 
if :NEW.container_check_id is null then 
select somerandomsequence.nextval into :new.container_check_id from dual;
end if;
if :NEW.check_date is null then 
:NEW.check_date:= sysdate;
end if; 
end; 


ALTER TRIGGER "CONTAINER_CHECK_ID" ENABLE