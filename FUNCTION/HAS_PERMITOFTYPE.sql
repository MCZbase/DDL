
  CREATE OR REPLACE EDITIONABLE FUNCTION "HAS_PERMITOFTYPE" (
a_transaction_id in number,
a_permit_type in varchar2
)
return number
-- Given a transaction_id, and a permit type identify whether the specified transaction
-- has a permit of the specified type linked either directly or through a shipment.
-- @param  a_transaction_id the transaction_id of the transaction to check.
-- @param a_permit_type the permit_type to check for
-- @return 1 if the specified transaction has a permit of the specified type linked 
-- either directly or through a shipment, otherwise 0.
as
has_type number;
begin
select case count(*) when 0 then 0 else 1 end into has_type from permit where
permit_id in (
  select permit_id from
  permit_trans where transaction_id = a_transaction_id
  union
  select permit_id from permit_shipment left join shipment on
  permit_shipment.shipment_id = shipment.shipment_id
  where shipment.transaction_id = a_transaction_id
)
and permit_type = a_permit_type
;
return has_type;
end has_permitoftype;
-- create public synonym HAS_PERMITOFTYPE for mczbase.HAS_PERMITOFTYPE;
-- grant execute on HAS_PERMITOFTYPE to manage_transactions;