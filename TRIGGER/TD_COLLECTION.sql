
  CREATE OR REPLACE TRIGGER "TD_COLLECTION" after DELETE on Collection for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- DELETE trigger on Collection
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Collection R/133 Cataloged_Item ON PARENT DELETE RESTRICT */
    select count(*) into numrows
      from Cataloged_Item
      where
        /*  %JoinFKPK(Cataloged_Item,:%Old," = "," and") */
        Cataloged_Item.Collection_id = :old.Collection_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20001,
        'Cannot DELETE "Collection" because "Cataloged_Item" exists.'
      );
    end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TD_COLLECTION" ENABLE