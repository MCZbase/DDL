
  CREATE OR REPLACE PROCEDURE "LOAD_ENT_ACCNS" as

cursor c1 is select * from X_ENT_HISTORICAL_ACCN20230713 where moved is null or moved = 'X';
/*cursor c1 is select * from X_ENT_HISTORICAL_ACCN20230713 x join x_ent_accnagentfix af on  x.ADDITIONAL_OUTSIDE_CONTACT2 = af.agent_name where moved is null or moved = 'X' and error like '%ADDITIONAL%';*/

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

debug_step := 'inserting transaction';
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
					to_date(c1_rec.accession_date, 'YYYY-MM-DD'),
					0,
					'accn',
					c1_rec.NATURE_OF_MATERIAL,
					9,
                    c1_rec.INTERNAL_REMARKS
					)
returning transaction_id into numTRANSID;

debug_step := 'inserting accn';
INSERT INTO accn (
					TRANSACTION_ID,
					ACCN_TYPE,
					ACCN_NUMBER
                    ,ACCN_status
					,received_date
                    ,received_date_text
                    ,estimated_count
					 )
				values (
					numTRANSID,
					c1_rec.ACCESSION_TYPE,
					c1_rec.ACCESSION_number
                    ,c1_rec.ACCESSION_status
                    ,to_date(c1_rec.received_date, 'YYYY-MM-DD')
                    ,c1_rec.received_date
                    ,decode(c1_rec.estimated_count, 'unknown', NULL, to_number(c1_rec.estimated_count))
					);

debug_step := 'received_from';
if c1_rec.received_from is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.received_from group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'received_from not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple received_from found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.received_from;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'received from');
    end if;
/*        numAgentID := c1_rec.agent_id;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'received from');*/
end if;
debug_step := 'ADDITIONAL_OUTSIDE_CONTACT';
if c1_rec.ADDITIONAL_OUTSIDE_CONTACT is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.ADDITIONAL_OUTSIDE_CONTACT group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'ADDITIONAL_OUTSIDE_CONTACT not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple ADDITIONAL_OUTSIDE_CONTACT found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.ADDITIONAL_OUTSIDE_CONTACT;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'outside contact');
    end if;
        /*numAgentID := c1_rec.agent_id;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'outside contact');*/
end if;
debug_step := 'ADDITIONAL_OUTSIDE_CONTACT2';
if c1_rec.ADDITIONAL_OUTSIDE_CONTACT2 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.ADDITIONAL_OUTSIDE_CONTACT2 group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'ADDITIONAL_OUTSIDE_CONTACT2 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple ADDITIONAL_OUTSIDE_CONTACT2 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.ADDITIONAL_OUTSIDE_CONTACT2;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'additional outside contact');
    end if;
    /*numAgentID := c1_rec.agent_id;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'additional outside contact');*/
end if;
debug_step := 'ADDITIONAL_OUTSIDE_CONTACT3';
if c1_rec.ADDITIONAL_OUTSIDE_CONTACT3 is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.ADDITIONAL_OUTSIDE_CONTACT3 group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'ADDITIONAL_OUTSIDE_CONTACT3 not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple ADDITIONAL_OUTSIDE_CONTACT3 found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.ADDITIONAL_OUTSIDE_CONTACT3;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'additional outside contact');
    end if;
end if;
debug_step := 'IN_HOUSE_AUTHORIZED_BY';
if c1_rec.IN_HOUSE_AUTHORIZED_BY is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.IN_HOUSE_AUTHORIZED_BY group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'IN_HOUSE_AUTHORIZED_BY not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple IN_HOUSE_AUTHORIZED_BY found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.IN_HOUSE_AUTHORIZED_BY;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'in-house authorized by');
    end if;
end if;
debug_step := 'IN_HOUSE_CONTACT';
if c1_rec.IN_HOUSE_CONTACT is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.IN_HOUSE_CONTACT group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'IN_HOUSE_CONTACT not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple IN_HOUSE_CONTACT found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.IN_HOUSE_CONTACT;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'in-house contact');
    end if;
end if;
debug_step := 'ADDITIONAL_IN_HOUSE_CONTACT';
if c1_rec.ADDITIONAL_IN_HOUSE_CONTACT is not null then
    select count(*) into cnt from 
        (select agent_name, agent_id from agent_name where agent_name = c1_rec.ADDITIONAL_IN_HOUSE_CONTACT group by agent_name, agent_id);
    
    if cnt = 0 then 
        err_msg := 'ADDITIONAL_IN_HOUSE_CONTACT not found';
        raise failed_validation;
    elsif cnt > 1 then 
        err_msg := 'multiple ADDITIONAL_IN_HOUSE_CONTACT found';
        raise failed_validation;
    elsif cnt = 1 then
        select distinct agent_id into numAgentID from agent_name where agent_name = c1_rec.ADDITIONAL_IN_HOUSE_CONTACT;
        insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, numAgentID, 'additional in-house contact');
    end if;
end if;

insert into trans_agent(transaction_id, agent_id, trans_agent_role)
        values(numTRANSID, 108699, 'entered by');

update X_ENT_HISTORICAL_ACCN20230713 set transaction_id = numTRANSID, moved = 'Y', error = null where ID = numID;
commit;

      EXCEPTION
            
       when failed_validation then 
       ROLLBACK;
       update X_ENT_HISTORICAL_ACCN20230713 set error = err_msg, moved = 'X' where ID = numID;
       commit;
  
       WHEN OTHERS THEN
       ROLLBACK;
       err_num := SQLCODE;
       err_msg := SUBSTR(debug_step || ':' || SQLERRM, 1, 512);
       UPDATE X_ENT_HISTORICAL_ACCN20230713 SET error = err_num || ': ' || err_msg, moved = 'X' WHERE ID=numID;
       COMMIT;

       
    end;

end loop;
end;