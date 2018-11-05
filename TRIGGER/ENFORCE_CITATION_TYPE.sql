
  CREATE OR REPLACE TRIGGER "ENFORCE_CITATION_TYPE" 
    before UPDATE or INSERT ON citation
    for each row
declare
    IS_PEER_REVIEWED_FG publication.IS_PEER_REVIEWED_FG%TYPE;
BEGIN
SELECT IS_PEER_REVIEWED_FG INTO IS_PEER_REVIEWED_FG FROM publication WHERE publication_id=:new.publication_id;
IF IS_PEER_REVIEWED_FG = 1 AND :new.type_status = 'referral' THEN
   raise_application_error(
            -20001,
            'Invalid type_status for this is_peer_reviewed_fg'
          );
ELSIF IS_PEER_REVIEWED_FG = 0 AND :new.type_status != 'referral' THEN
    raise_application_error(
            -20001,
            'Invalid type_status for this is_peer_reviewed_fg'
          );
END IF;
END;

ALTER TRIGGER "ENFORCE_CITATION_TYPE" DISABLE