
  CREATE OR REPLACE EDITIONABLE TRIGGER "SPECIMEN_PART_CT_CHECK" 
BEFORE UPDATE OR INSERT ON SPECIMEN_PART
FOR EACH ROW
DECLARE
numrows number;
collectionCode varchar2(10);
BEGIN
SELECT collection.collection_cde
INTO collectionCode
FROM
    collection,
    cataloged_item
    WHERE collection.collection_id = cataloged_item.collection_id
    AND cataloged_item.collection_object_id = :NEW.derived_from_cat_item;

SELECT COUNT(*) INTO numrows
FROM ctspecimen_part_name
WHERE part_name = :NEW.part_name
AND collection_cde = collectionCode;

IF (numrows = 0) THEN
        raise_application_error(
    -20001,
'Invalid part name');
END IF;

SELECT COUNT(*) INTO numrows
FROM ctspecimen_preserv_method
WHERE preserve_method = :NEW.preserve_method
AND collection_cde = collectionCode;

IF (numrows = 0) THEN
        raise_application_error(
    -20001,
'Invalid preserve method');
END IF;

END;

ALTER TRIGGER "SPECIMEN_PART_CT_CHECK" ENABLE