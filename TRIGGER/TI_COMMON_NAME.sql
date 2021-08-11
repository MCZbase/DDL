
  CREATE OR REPLACE TRIGGER "TI_COMMON_NAME" after INSERT on "MCZBASE"."COMMON_NAME" for each row
-- ERwin Builtin Wed May 05 11:26:47 2004
-- INSERT trigger on Common_Name
declare numrows INTEGER;
begin
    /* ERwin Builtin Wed May 05 11:26:47 2004 */
    /* Taxonomy R/512 Common_Name ON CHILD INSERT RESTRICT */
    select count(*) into numrows
      from Taxonomy
      where
        /* %JoinFKPK(:%New,Taxonomy," = "," and") */
        :new.Taxon_Name_id = Taxonomy.Taxon_Name_id;
    if (
      /* %NotnullFK(:%New," is not null and") */

      numrows = 0
    )
    then
      raise_application_error(
        -20002,
        'Cannot INSERT "Common_Name" because "Taxonomy" does not exist.'
      );
    end if;


   

-- ERwin Builtin Wed May 05 11:26:47 2004
end;
ALTER TRIGGER "TI_COMMON_NAME" ENABLE