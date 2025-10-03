
  CREATE OR REPLACE EDITIONABLE TRIGGER "TU_LOAN_ITEM" after UPDATE on Loan_Item for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- UPDATE trigger on Loan_Item
declare numrows INTEGER;
begin
  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Person R/212 Loan_Item ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Person
    where
      /* %JoinFKPK(:%New,Person," = "," and") */
      :new.Reconciled_By_Person_id = Person.Person_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Loan_Item" because "Person" does not exist.'
    );
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Coll_Object R/196 Loan_Item ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Coll_Object
    where
      /* %JoinFKPK(:%New,Coll_Object," = "," and") */
      :new.Collection_Object_id = Coll_Object.Collection_Object_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Loan_Item" because "Coll_Object" does not exist.'
    );
  end if;

  /* ERwin Builtin Wed May 05 11:26:47 2004 */
  /* Loan R/195 Loan_Item ON CHILD UPDATE RESTRICT */
  select count(*) into numrows
    from Loan
    where
      /* %JoinFKPK(:%New,Loan," = "," and") */
      :new.Transaction_id = Loan.Transaction_id;
  if (
    /* %NotnullFK(:%New," is not null and") */

    numrows = 0
  )
  then
    raise_application_error(
      -20007,
      'Cannot UPDATE "Loan_Item" because "Loan" does not exist.'
    );
  end if;


-- ERwin Builtin Wed May 05 11:26:47 2004
end;




ALTER TRIGGER "TU_LOAN_ITEM" ENABLE