
  CREATE OR REPLACE TRIGGER "TU_LOAN" after UPDATE on Loan for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Loan
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Loan R/195 Loan_Item ON PARENT UPDATE RESTRICT */
  if
    /* %JoinPKPK(:%Old,:%New," <> "," or ") */
    :old.Transaction_id <> :new.Transaction_id
  then
    select count(*) into numrows
      from Loan_Item
      where
        /*  %JoinFKPK(Loan_Item,:%Old," = "," and") */
        Loan_Item.Transaction_id = :old.Transaction_id;
    if (numrows > 0)
    then
      raise_application_error(
        -20005,
        'Cannot UPDATE "Loan" because "Loan_Item" exists.'
      );
    end if;
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Trans  Loan ON CHILD UPDATE RESTRICT */
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
      'Cannot UPDATE "Loan" because "Trans" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;



ALTER TRIGGER "TU_LOAN" ENABLE