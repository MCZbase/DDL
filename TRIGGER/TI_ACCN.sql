
  CREATE OR REPLACE TRIGGER "TI_ACCN" after INSERT on Accn for each row
-- ERwin Builtin Mon May 17 12:58:26 2004
-- INSERT trigger on Accn
declare numrows INTEGER;
begin
    /* ERwin Builtin Mon May 17 12:58:26 2004 */
    /* Trans  Accn ON CHILD INSERT RESTRICT */
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
        -20002,
        'Cannot INSERT "Accn" because "Trans" does not exist.'
      );
    end if;


-- ERwin Builtin Mon May 17 12:58:26 2004

    
end;
ALTER TRIGGER "TI_ACCN" ENABLE