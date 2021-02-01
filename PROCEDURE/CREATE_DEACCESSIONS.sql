
  CREATE OR REPLACE PROCEDURE "CREATE_DEACCESSIONS" as

transID number;
newDeaccNum mczbase.deaccession.deacc_number%TYPE;
rb_aid number;
ri_aid number;
/*cursor c1 is select distinct to_date(fixed_date, 'DD MON YYYY') as transdate, fixed_date from x_mamm_deacc where deacc_num is null order by to_date(fixed_date, 'DD MON YYYY');*/

cursor c1 is select distinct received_by, deacc_date, authorized_by, in_house_contact, recipient_institution, nature_of_material, reason_for_deaccession, internal_remarks, deaccession_type, deaccession_status, deacc_date_date 
from x_herp_deacc where trans_id is null;

begin

for c1_rec in c1 loop

/*
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
INSERT INTO trans (TRANSACTION_ID, TRANS_DATE, CORRESP_FG, TRANSACTION_TYPE, NATURE_OF_MATERIAL, collection_id,trans_remarks)
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
returning transaction_id into transID;*/


INSERT INTO trans (TRANSACTION_ID, TRANS_DATE, CORRESP_FG, TRANSACTION_TYPE, NATURE_OF_MATERIAL, collection_id,trans_remarks)
values(sq_transaction_id.nextval,c1_rec.deacc_date_date, 0,'deaccession', c1_rec.NATURE_OF_MATERIAL ,2,c1_rec.internal_remarks)
returning transaction_id into transID;

select 
    regexp_substr(max(deacc_number), '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',1) ||  
    to_char(max(to_number(regexp_substr(deacc_number, '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',2)))+1) || 
    regexp_substr(max(deacc_number), '(D[0-9]{4}\-)([0-9]*)(\-[A-Za-z]*$)', 1,1,'i',3) into newDeaccNum
from deaccession where deacc_number like '%Herp' and instr(deacc_number, 'D' || to_char(c1_rec.deacc_date_date, 'YYYY')) > 0;

if newDeaccNum is null then
    newDeaccNum := 'D' || to_char(c1_rec.deacc_date_date, 'YYYY') || '-1-Herp';
end if;

DBMS_OUTPUT.PUT_LINE(newDeaccNum);

INSERT INTO deaccession (TRANSACTION_ID, DEACC_TYPE, DEACC_NUMBER ,deacc_status ,DEACC_REASON)					 
values (transID, c1_rec.deaccession_type, newDeaccNum, c1_rec.deaccession_status, c1_rec.reason_for_deaccession);

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, 16250,'authorized by');

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, 16250,'in-house contact');

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, 16250,'entered by');


select agent_id into rb_aid from agent_name where agent_name = c1_rec.received_by;

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, rb_aid,'received by');

select agent_id into ri_aid from agent_name where agent_name = c1_rec.recipient_institution and agent_name_type <> 'aka';

INSERT INTO trans_agent ( transaction_id, agent_id,	trans_agent_role) 
values (transID, ri_aid,'recipient institution');

update x_herp_deacc set newDN = newDeaccNum, trans_id = transID where
received_by = c1_rec.received_by and
deacc_date = c1_rec.deacc_date and
recipient_institution = c1_rec.recipient_institution and
nature_of_material = c1_rec.nature_of_material and 
nvl(internal_remarks, 'XXX') = nvl(c1_rec.internal_remarks, 'XXX') and 
deaccession_type=c1_rec.deaccession_type;

end loop;

end;