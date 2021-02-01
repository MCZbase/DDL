
  CREATE OR REPLACE FORCE VIEW "TRANSACTION_VIEW" ("TRANSACTION_ID", "TRANS_DATE", "TRANSACTION_TYPE", "NATURE_OF_MATERIAL", "TRANS_REMARKS", "COLLECTION_ID", "SPECIFIC_TYPE", "STATUS", "SPECIFIC_NUMBER") AS 
  select trans.transaction_id, trans_date, transaction_type, nature_of_material, 
trans_remarks, trans.collection_id,
loan_type as specific_type, loan_status as status, loan_number as specific_number
from trans join loan on trans.transaction_id = loan.transaction_id
union all
select trans.transaction_id, trans_date, transaction_type, nature_of_material, 
trans_remarks, trans.collection_id,
deacc_type as specific_type, deacc_status as status, deacc_number as specific_number
from trans join deaccession on trans.transaction_id = deaccession.transaction_id
union all
select trans.transaction_id, trans_date, transaction_type, nature_of_material, 
trans_remarks, trans.collection_id,
'' as specific_type, borrow_status as status, borrow_number as specific_number
from trans join borrow on trans.transaction_id = borrow.transaction_id
union all
select trans.transaction_id, trans_date, transaction_type, nature_of_material, 
trans_remarks, trans.collection_id,
accn_type as specific_type, accn_status as status, accn_number as specific_number
from trans join accn on trans.transaction_id = accn.transaction_id