
  CREATE OR REPLACE EDITIONABLE TRIGGER "TU_COLLECTION" after UPDATE on Collection for
 each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Collection
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Collection R/133 Cataloged_Item ON PARENT UPDATE RESTRICT */
  if
    /* %JoinPKPK(:%Old,:%New," <> "," or ") */
    :old.Collection_id <> :new.Collection_id
  then
    select count(*) into numrows
      from Cataloged_Item
      where
        /*  %JoinFKPK(Cataloged_Item,:%Old," = "," and") */
        Cataloged_Item.Collection_id = :old.Collection_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20005,
        'Cannot UPDATE "Collection" because "Cataloged_Item" exists.'
      );
    end if;
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;




ALTER TRIGGER "TU_COLLECTION" ENABLE