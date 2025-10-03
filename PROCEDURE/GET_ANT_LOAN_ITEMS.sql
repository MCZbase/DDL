
  CREATE OR REPLACE EDITIONABLE PROCEDURE "GET_ANT_LOAN_ITEMS" as

cursor c1 is select t.transaction_id, nature_of_material, loan_number
from loan l, trans t 
where l.transaction_id = t.transaction_id
and upper(T.NATURE_OF_MATERIAL) like '%FORMICIDAE%'
and regexp_like(T.NATURE_OF_MATERIAL, '#[0-9]{1,6}');

numCatNum number;
varLoanNumber loan.loan_number%type;
numTransactionID number;
numCollObjID number;
varNatureOfMaterial trans.nature_of_material%type;
x number;
numNumofParts number;
numCatItemFound number;
numPartId number;
numItems number;

begin
dbms_output.put_line('starting');
for c1_rec in c1 loop
    varNatureOfMaterial := c1_rec.nature_of_material;
    numTransactionID := c1_rec.transaction_id;
    varLoanNumber := c1_rec.Loan_Number;
    x:=1;
    numCatNum := 9999999999;
    numItems := 0;
    
    while numCatNum is not null
    LOOP
        numCatNum := regexp_substr(varNatureOfMaterial, '(#)([0-9]{1,6})',1, x, 'i', 2);
        if numCatNum is not null then
            select count(*) into numCatItemFound from cataloged_item where cat_num_integer = numCatNum and cat_num_prefix is null and collection_cde = 'Ent';
            if numCatItemFound = 1 then 
                select collection_object_id into numCollObjID from cataloged_item where cat_num_integer = numCatNum and cat_num_prefix is null and collection_cde = 'Ent';
                select count(*) into numNumofParts from specimen_part where derived_from_cat_item = numCollObjID;
                select min(collection_object_id) into numPartId  from specimen_part where derived_from_cat_item = numCollObjID;
                select count(*) into numItems from loan_item where transaction_id = numTransactionID and collection_object_id = numPartId;
                
                if numItems = 0 then NULL;
                    dbms_output.put_line(numTransactionID || ',' || numCollObjID);
                    insert into loan_item(transaction_id, collection_Object_id, reconciled_by_person_id, item_descr)
                    values(numTransactionID, numPartID, 0, 'Ent ' || numCatNum);
                end if;
            else       
                numNumofParts := 0;
                numPartID :=null;
            end if;
            dbms_output.put_line(numTransactionID || ',' ||  varLoanNumber || ',' || numCatNum || ',' || numCatItemFound || ',' || numNumofParts);
            insert into X_ANT_LOAN_ITEM_LOG(transaction_id, loan_number, cat_num, cat_num_found, number_of_parts, item_added)
                values(numTransactionID, varLoanNumber, numCatNum, numCatItemFound, numNumofParts, decode(numItems, 0, numPartId, numItems));
                commit;
            x:=x+1;
        end if;
    END LOOP;
end loop;
end;