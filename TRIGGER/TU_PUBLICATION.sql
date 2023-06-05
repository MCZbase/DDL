
  CREATE OR REPLACE TRIGGER "TU_PUBLICATION" AFTER INSERT OR UPDATE ON MCZBASE.PUBLICATION 
FOR EACH ROW
BEGIN
  delete from formatted_publication where publication_id = :NEW.publication_id;

 insert into formatted_publication (publication_id, format_style, formatted_publication)
  values 
 (:NEW.publication_id, 
  'long', 
  (select assemble_fullcitation_tr(:NEW.publication_id, :NEW.publication_title, :NEW.published_year, :NEW.doi, :NEW.publication_type) from dual)
  );

  insert into formatted_publication (publication_id, format_style, formatted_publication)
    values 
  (:NEW.publication_id, 'short', (select assemble_shortcitation_tr(:NEW.publication_id, :NEW.publication_title, :NEW.published_year) from dual));

END;

ALTER TRIGGER "TU_PUBLICATION" ENABLE