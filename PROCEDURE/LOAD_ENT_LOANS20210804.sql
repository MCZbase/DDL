
  CREATE OR REPLACE PROCEDURE "LOAD_ENT_LOANS20210804" as

cursor c1 is select * from x_entloans_20210804 where moved is null or moved = 'X';
numTRANSID number;
cnt number;
err_num varchar(100);
err_msg varchar(1000);
numAGENTID number;
numID number;
failed_validation EXCEPTION;
debug_step varchar(50);
begin

for c1_rec in c1 loop
begin
numID := c1_rec.ID;
err_msg := null;

select count(*) into cnt from loan where loan_number = c1_rec.loan_number;

if cnt = 0 then 
debug_step := 'inserting trans';
INSERT INTO trans (
					TRANSACTION_ID,
					TRANS_DATE,
					CORRESP_FG,
					TRANSACTION_TYPE,
					NATURE_OF_MATERIAL,
					collection_id,
                    trans_remarks
)
				VALUES (
					sq_transaction_id.nextval,
					c1_rec.transaction_date,
					0,
					'loan',
					c1_rec.NATURE_OF_MATERIAL,
					9,
                    c1_rec.INTERNAL_REMARKS
					)
returning transaction_id into numTRANSID;
debug_step := 'inserting loan';
INSERT INTO loan (
					TRANSACTION_ID,
					LOAN_TYPE,
					LOAN_NUMBER
                    ,loan_status
					,return_due_date
                    ,LOAN_INSTRUCTIONS
                    ,loan_description
                    ,closed_date
					 )
				values (
					numTRANSID,
					c1_rec.loan_type,
					c1_rec.loan_number
                    ,c1_rec.loan_status
                    ,to_date(c1_rec.return_due_date, 'YYYY-MM-DD')
                    ,c1_rec.LOAN_INSTRUCTIONS
                    ,c1_rec.description
                    ,to_date(c1_rec.date_closed, 'YYYY-MM-DD')
					);

debug_step := 'in house authorized by';
if c1_rec.in_house_authorized_by is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.in_house_authorized_by group by agent_name, agent_id);

    if cnt = 0 then 
        err_msg := 'in_house_authorized_by not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple in_house_authorized_by found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.in_house_authorized_by;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'in-house authorized by');
    end if;
end if;
debug_step := 'recieved_by';
if c1_rec.recieved_by is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.recieved_by group by agent_name, agent_id);

    if cnt = 0 then 
        err_msg := 'received_by not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple received_by found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.recieved_by;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'received by');
    end if;
end if;
debug_step := 'in_house_contact';
if c1_rec.in_house_contact is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.in_house_contact group by agent_name, agent_id);

    if cnt = 0 then 
        err_msg := 'in_house_contact not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple in_house_contact found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.in_house_contact;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'in-house contact');
    end if;
end if;
debug_step := 'recipient_institution';
if c1_rec.recipient_institution is not null and c1_rec.recipient_institution <> 'N/A' then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where lower(trim(agent_name)) = lower(trim(c1_rec.recipient_institution)) group by agent_name, agent_id);

    if cnt = 0 then 
        err_msg := 'recipient_institution not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple recipient_institution found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where lower(trim(agent_name)) = lower(trim(c1_rec.recipient_institution));
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'recipient institution');
    end if;
end if;
debug_step := 'for_use_by';
if trim(c1_rec.for_use_by) is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.for_use_by group by agent_name, agent_id);

    if cnt = 0 then 
        err_msg := 'for_use_by not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple for_use_by found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.for_use_by;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'for use by');
    end if;
end if;
debug_step := 'additional_outside_contact';
if c1_rec.additional_outside_contact is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.additional_outside_contact group by agent_name, agent_id);

    if cnt = 0 then 
        err_msg := 'additional_outside_contact not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple additional_outside_contact found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.additional_outside_contact;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'additional outside contact');
    end if;
end if;
/*debug_step := 'agent7';
if c1_rec.agent_name_7 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.agent_name_7 group by agent_name, agent_id);

    if cnt = 0 then 
        err_msg := 'agent_name_7 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple agent_name_7 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.agent_name_7;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, c1_rec.agent_type_7);
    end if;
end if;*/
debug_step := 'inserting entered_by';
insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, 108699, 'entered by');
debug_step := 'updating loan table';
update x_entloans_20210804 set transaction_id = numTRANSID, moved = 'Y', error = null where ID = numID;
commit;

else 
    err_msg := 'loan exists';
    raise failed_validation;
end if;

      EXCEPTION

       when failed_validation then 
       ROLLBACK;
       update x_entloans_20210804 set error = err_msg, moved = 'X' where ID = numID;
       commit;

       WHEN OTHERS THEN
       ROLLBACK;
       err_num := SQLCODE;
       err_msg := SUBSTR(debug_step || ':' || SQLERRM, 1, 512);
       UPDATE x_entloans_20210804 SET error = err_num || ': ' || err_msg, moved = 'X' WHERE ID=numID;
       COMMIT;


    end;

end loop;
end;