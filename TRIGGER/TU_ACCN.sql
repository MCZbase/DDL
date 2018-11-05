
  CREATE OR REPLACE TRIGGER "TU_ACCN" after UPDATE on Accn for each row
-- ERwin Builtin Mon May 17 12:58:26 2004
-- UPDATE trigger on Accn
declare numrows INTEGER;
begin
  /* ERwin Builtin Mon May 17 12:58:26 2004 */
  /* Accn R/127 Cataloged_Item ON PARENT UPDATE RESTRICT */
  if
    /* %JoinPKPK(:%Old,:%New," <> "," or ") */
    :old.Transaction_id <> :new.Transaction_id
  then
    select count(*) into numrows
      from Cataloged_Item
      where
        /*  %JoinFKPK(Cataloged_Item,:%Old," = "," and") */
        Cataloged_Item.Accn_id = :old.Transaction_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20005,
        'Cannot UPDATE "Accn" because "Cataloged_Item" exists.'
      );
    end if;
  end if;

  /* ERwin Builtin Mon May 17 12:58:26 2004 */
  /* Trans  Accn ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Trans
    where
      /* %JoinFKPK(:%New,Trans," = "," and") */
      :new.Transaction_id = Trans.Transaction_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Accn" because "Trans" does not exist.'
    );
  end if;


-- ERwin Builtin Mon May 17 12:58:26 2004
end;



ALTER TRIGGER "TU_ACCN" ENABLE