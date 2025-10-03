
  CREATE OR REPLACE EDITIONABLE TRIGGER "TI_ACCN_CK_NUMNBER" before INSERT on Accn for each row
-- ERwin Builtin Mon May 17 12:58:26 2004
-- INSERT trigger on Accn
declare numrows INTEGER;
begin
    /* ERwin Builtin Mon May 17 12:58:26 2004 */
    /* Trans  Accn ON CHILD INSERT RESTRICT */
    select count(*) into numrows
      from accn
      where
        /* %JoinFKPK(:%New,Trans," = "," and") */
        :new.accn_number = accn.accn_number;
    if (
      /* %NotnullFK(:%New," is not null and") */

      numrows > 0
    )
    then
      raise_application_error(
        -20002,
        'Cannot INSERT "Accn" because "Accession Number" already exists.'
      );
    end if;


-- ERwin Builtin Mon May 17 12:58:26 2004

    
end;

ALTER TRIGGER "TI_ACCN_CK_NUMNBER" ENABLE