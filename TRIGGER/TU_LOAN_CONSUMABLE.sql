
  CREATE OR REPLACE TRIGGER "TU_LOAN_CONSUMABLE" after update on LOAN
FOR EACH ROW
declare 
newdeaccid number;
collid number;
newdeaccnumber deaccession.deacc_number%type;
collcde cataloged_item.collection_cde%type;
loanId number;
loanNumber loan.loan_number%type;
numDeaccItems number;

BEGIN

If :new.loan_status <> :old.loan_status and :new.loan_type = 'consumable' and :new.loan_status = 'closed' then
    loanId := :NEW.transaction_id;
    loanNumber := :NEW.loan_number;

--check to see if there is anything to deaccession

select count(*) into numDeaccItems
    from loan_item li, coll_object co 
    where li.collection_object_id = co.collection_object_id  
    and co.coll_obj_disposition <> 'in collection'
    and li.transaction_id = loanID;

--if there are items to deaccession, create a deaccession

    if numDeaccItems > 0 then 

        select c.collection_id, c.collection_cde 
            into collID, collCDE 
            from trans t, collection c
            where t.transaction_id = loanId
            and t.collection_id = c.collection_id;
    
        select sq_transaction_id.nextval into newDeaccId from dual;
        
        insert into trans(transaction_id, trans_date, corresp_fg, transaction_type, nature_of_material, collection_id, trans_remarks)
        select newDeaccId, sysdate, 0, 'deaccession', nature_of_material, collection_id, trans_remarks from trans where transaction_id = loanId;
    
        select 'D' || to_char(sysdate, 'YYYY') || '-' || nvl(max(to_number(regexp_substr(deacc_number,'[^-]+', 1, 2))) + 1,'1') || '-' || collCDE into newDeaccNumber
        from
            deaccession d,
            trans t,
            collection c
        where
            d.transaction_id = t.transaction_id and 
            t.collection_id = c.collection_id and 
            c.collection_id = collID and
            substr(deacc_number, 2,4) =to_char(sysdate, 'YYYY');
    
        insert into deaccession(transaction_id, deacc_type, deacc_number, deacc_status, deacc_reason, value)
        values(newDeaccId, 'used up', newDeaccNumber, 'in process', 'material used up as part of consumable loan ' || :new.loan_number, :new.insurance_value);
        
        INSERT INTO TRANS_AGENT(TRANSACTION_ID, AGENT_ID, TRANS_AGENT_ROLE)
        select newDeaccId, agent_id, trans_agent_role from trans_agent where transaction_id = loanId and trans_agent_role <> 'entered by';
        
        insert into shipment(TRANSACTION_ID,PACKED_BY_AGENT_ID,SHIPPED_CARRIER_METHOD,CARRIERS_TRACKING_NUMBER,SHIPPED_DATE,PACKAGE_WEIGHT,HAZMAT_FG,INSURED_FOR_INSURED_VALUE,SHIPMENT_REMARKS,CONTENTS,FOREIGN_SHIPMENT_FG,SHIPPED_TO_ADDR_ID,SHIPPED_FROM_ADDR_ID,NO_OF_PACKAGES,PRINT_FLAG)
        select newDeaccId,PACKED_BY_AGENT_ID,SHIPPED_CARRIER_METHOD,CARRIERS_TRACKING_NUMBER,SHIPPED_DATE,PACKAGE_WEIGHT,HAZMAT_FG,INSURED_FOR_INSURED_VALUE,SHIPMENT_REMARKS,CONTENTS,FOREIGN_SHIPMENT_FG,SHIPPED_TO_ADDR_ID,SHIPPED_FROM_ADDR_ID,NO_OF_PACKAGES,PRINT_FLAG
        from shipment where transaction_id = loanID;
        
        insert into deacc_item(transaction_id, collection_object_id, reconciled_by_person_id, reconciled_date, item_descr, item_instructions, deacc_item_remarks)
        select newDeaccId, li.collection_object_ID, reconciled_by_person_id, reconciled_date, item_descr, item_instructions,loan_item_remarks 
            from loan_item li, coll_object co 
            where li.collection_object_id = co.collection_object_id  
            and co.coll_obj_disposition <> 'in collection'
            and li.transaction_id = loanID;
    end if;
end if;

end;
ALTER TRIGGER "TU_LOAN_CONSUMABLE" ENABLE