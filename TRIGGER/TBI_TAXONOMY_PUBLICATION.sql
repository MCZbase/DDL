
  CREATE OR REPLACE TRIGGER "TBI_TAXONOMY_PUBLICATION" before insert  ON taxonomy_publication for each row
    begin
        select seq_taxonomy_publication.nextval into :new.taxonomy_publication_id from dual;
    end;

ALTER TRIGGER "TBI_TAXONOMY_PUBLICATION" ENABLE