
  CREATE OR REPLACE PROCEDURE "LOAD_ENT_LOANS" as

cursor c1 is select * from x_entloans2 where moved is null or moved = 'X';
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

select count(*) into cnt from loan where loan_number = c1_rec.mczbase_loan_number;

if cnt = 0 then 

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

INSERT INTO loan (
					TRANSACTION_ID,
					LOAN_TYPE,
					LOAN_NUMBER
                    ,loan_status
					,return_due_date
                    ,LOAN_INSTRUCTIONS
                    ,loan_description
					 )
				values (
					numTRANSID,
					c1_rec.loan_type,
					c1_rec.mczbase_loan_number
                    ,c1_rec.loan_status
                    ,to_date(c1_rec.return_due_date, 'YYYY-MM-DD')
                    ,c1_rec.LOAN_INSTRUCTIONS
                    ,c1_rec.description
					);

debug_step := 'agent1';
if c1_rec.agent_name_1 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.agent_name_1 group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'agent_name_1 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple agent_name_1 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.agent_name_1;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, c1_rec.agent_type_1);
    end if;
end if;
debug_step := 'agent2';
if c1_rec.agent_name_2 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.agent_name_2 group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'agent_name_2 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple agent_name_2 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.agent_name_2;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, c1_rec.agent_type_2);
    end if;
end if;
debug_step := 'agent3';
if c1_rec.agent_name_3 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.agent_name_3 group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'agent_name_3 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple agent_name_3 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.agent_name_3;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, c1_rec.agent_type_3);
    end if;
end if;
debug_step := 'agent4';
if c1_rec.agent_name_4 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.agent_name_4 group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'agent_name_4 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple agent_name_4 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.agent_name_4;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, c1_rec.agent_type_4);
    end if;
end if;
debug_step := 'agent5';
if c1_rec.agent_name_5 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.agent_name_5 group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'agent_name_5 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple agent_name_5 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.agent_name_5;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, c1_rec.agent_type_5);
    end if;
end if;
debug_step := 'agent6';
if c1_rec.agent_name_6 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.agent_name_6 group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'agent_name_6 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple agent_name_6 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.agent_name_6;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, c1_rec.agent_type_6);
    end if;
end if;
debug_step := 'agent7';
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
end if;

insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, 98082, 'entered by');

update x_entloans2 set transaction_id = numTRANSID, moved = 'Y', error = null where ID = numID;
commit;

else 
    err_msg := 'loan exists';
    raise failed_validation;
end if;

      EXCEPTION
            
       when failed_validation then 
       ROLLBACK;
       update x_entloans2 set error = err_msg, moved = 'X' where ID = numID;
       commit;
  
       WHEN OTHERS THEN
       ROLLBACK;
       err_num := SQLCODE;
       err_msg := SUBSTR(debug_step || ':' || SQLERRM, 1, 512);
       UPDATE x_entloans2 SET error = err_num || ': ' || err_msg, moved = 'X' WHERE ID=numID;
       COMMIT;

       
    end;

end loop;
end;