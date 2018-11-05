
  CREATE OR REPLACE PROCEDURE "CREATE_DEACCESSIONS" as

transID number;
newDeaccNum mczbase.deaccession.deacc_number%TYPE;

cursor c1 is select distinct to_date(fixed_date, 'DD MON YYYY') as transdate, fixed_date from x_mala_deacc where deacc_num is null order by to_date(fixed_date, 'DD MON YYYY');

begin

for c1_rec in c1 loop

--month day and year
INSERT INTO trans (TRANSACTION_ID, TRANS_DATE, CORRESP_FG, TRANSACTION_TYPE, NATURE_OF_MATERIAL, collection_id,trans_remarks)
values(sq_transaction_id.nextval,c1_rec.transdate, 0,'deaccession', 'specimens discarded on ' || trim(to_char(to_date(c1_rec.fixed_date, 'DD MON YYYY'), 'Month')) || trim(to_char(to_date(c1_rec.fixed_date, 'DD MON YYYY'), 'DD')) || ', ' || trim(to_char(to_date(c1_rec.fixed_date, 'DD MON YYYY'), 'YYYY')),3,'discarded information in most cases taken from annotations in the catalog ledger.')
returning transaction_id into transID;

select 
    regexp_substr(max(deacc_number), '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',1) ||  
    to_char(max(to_number(regexp_substr(deacc_number, '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',2)))+1) || 
    regexp_substr(max(deacc_number), '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',3) into newDeaccNum
from deaccession where deacc_number like '%Mala' and instr(deacc_number, 'D' || to_char(to_date(c1_rec.fixed_date, 'DD MON YYYY'), 'YYYY')) > 0;

if newDeaccNum is null then
    newDeaccNum := 'D' || to_char(to_date(c1_rec.fixed_date, 'DD MON YYYY'), 'YYYY') || '-1-Mala';
end if;

--month and year
/*INSERT INTO trans (TRANSACTION_ID, TRANS_DATE, CORRESP_FG, TRANSACTION_TYPE, NATURE_OF_MATERIAL, collection_id,trans_remarks)
values(sq_transaction_id.nextval,c1_rec.transdate, 0,'deaccession', 'specimens discarded in ' || trim(to_char(to_date(c1_rec.fixed_date, 'MON YYYY'), 'MONTH')) || ' ' || trim(to_char(to_date(c1_rec.fixed_date, 'MON YYYY'), 'YYYY')) || ' with no specific date beyond month. Transaction date set to last day of the month.',3,'discarded information in most cases taken from annotations in the catalog ledger.')
returning transaction_id into transID;

select 
    regexp_substr(max(deacc_number), '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',1) ||  
    to_char(max(to_number(regexp_substr(deacc_number, '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',2)))+1) || 
    regexp_substr(max(deacc_number), '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',3) into newDeaccNum
from deaccession where deacc_number like '%Mala' and instr(deacc_number, 'D' || to_char(to_date(c1_rec.fixed_date, 'MON YYYY'), 'YYYY')) > 0;

if newDeaccNum is null then
    newDeaccNum := 'D' || to_char(to_date(c1_rec.fixed_date, 'MON YYYY'), 'YYYY') || '-1-Mala';
end if;*/

--just year
/*INSERT INTO trans (TRANSACTION_ID, TRANS_DATE, CORRESP_FG, TRANSACTION_TYPE, NATURE_OF_MATERIAL, collection_id,trans_remarks)
values(sq_transaction_id.nextval,c1_rec.transdate, 0,'deaccession', 'specimens discarded in ' || c1_rec.fixed_date || ' with no specific date beyond year. Transaction date set to last day of year.',3,'discarded information in most cases taken from annotations in the catalog ledger.')
returning transaction_id into transID;

select 
    regexp_substr(max(deacc_number), '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',1) ||  
    to_char(max(to_number(regexp_substr(deacc_number, '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',2)))+1) || 
    regexp_substr(max(deacc_number), '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',3) into newDeaccNum
from deaccession where deacc_number like '%Mala' and instr(deacc_number, 'D' || c1_rec.fixed_date) > 0;

if newDeaccNum is null then
    newDeaccNum := 'D' || c1_rec.fixed_date || '-1-Mala';
end if;*/
DBMS_OUTPUT.PUT_LINE(newDeaccNum);



INSERT INTO deaccession (TRANSACTION_ID, DEACC_TYPE, DEACC_NUMBER ,deacc_status ,DEACC_REASON)					 
values (transID, 'discarded', newDeaccNum, 'closed', 'unknown');

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, 21623,'authorized by');

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, 21623,'in-house contact');

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, 21623,'entered by');

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, 15197,'received by');

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, 15197,'recipient institution');


update x_mala_deacc set deacc_num = newDeaccNum where fixed_date = c1_rec.fixed_date;

end loop;

end;