
  CREATE OR REPLACE EDITIONABLE TRIGGER "TR_BORROW_ITEM_ID_SQ" before insert ON borrow_item
for each row
begin
    IF :new.BORROW_ITEM_ID IS NULL THEN
        select sq_BORROW_ITEM_ID .nextval
        into :new.BORROW_ITEM_ID  from dual;
    END IF;
end;


ALTER TRIGGER "TR_BORROW_ITEM_ID_SQ" ENABLE