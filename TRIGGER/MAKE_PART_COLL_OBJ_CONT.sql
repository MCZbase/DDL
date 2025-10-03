
  CREATE OR REPLACE EDITIONABLE TRIGGER "MAKE_PART_COLL_OBJ_CONT" 
AFTER INSERT ON SPECIMEN_PART
FOR EACH ROW
DECLARE
    label varchar2(255);
    institution_acronym varchar2(255);
BEGIN
    SELECT
    collection.institution_acronym,
collection.collection_cde || ' ' || cataloged_item.cat_num ||
    ' ' || :NEW.part_name
    INTO
        institution_acronym,
        label
    FROM
        collection,
        cataloged_item
    WHERE collection.collection_id = cataloged_item.collection_id
    AND cataloged_item.collection_object_id = :NEW.derived_from_cat_item;

    INSERT INTO container (
    container_id,
parent_container_id,
container_type,
label,
locked_position,
institution_acronym)
VALUES (
sq_container_id.nextval,
1,
'collection object',
label,
0,
institution_acronym);

    INSERT INTO coll_obj_cont_hist (
collection_object_id,
container_id,
installed_date,
current_container_fg)
VALUES (
:NEW.collection_object_id,
sq_container_id.currval,
sysdate,
1);
EXCEPTION
    WHEN OTHERS THEN
    raise_application_error(
        -20000,
        'trigger problems: ' || SQLERRM);
END;

ALTER TRIGGER "MAKE_PART_COLL_OBJ_CONT" ENABLE