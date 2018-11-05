
  CREATE OR REPLACE TRIGGER "TR_SQ_PUB_URL_ID" 
BEFORE INSERT ON publication_url
FOR EACH ROW
BEGIN
    SELECT sq_publication_url_id.NEXTVAL into :new.publication_url_id FROM dual;
END;

ALTER TRIGGER "TR_SQ_PUB_URL_ID" ENABLE