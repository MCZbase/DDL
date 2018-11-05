
  CREATE OR REPLACE TRIGGER "TR_CTPARTASSO_UD" BEFORE
  UPDATE OR
  DELETE ON MCZBASE.CTPARTASSOCIATION FOR EACH ROW BEGIN FOR r IN
    (SELECT COUNT(*) c
    FROM attributes,
      cataloged_item,
      collection
    WHERE attributes.collection_object_id = cataloged_item.collection_object_id
    AND cataloged_item.collection_id      = collection.collection_id
    AND attribute_type                    = 'PARTASSOCIATION'
    AND attribute_value                   = :OLD.PARTASSOCIATION
    AND collection.collection_cde         = :OLD.collection_cde
    ) LOOP IF r.c                         > 0 THEN raise_application_error( -20001, :OLD.PARTASSOCIATION
    || ' is used in attributes for collection type '
    || :OLD.collection_cde);
END IF;
END LOOP;
END;
ALTER TRIGGER "TR_CTPARTASSO_UD" ENABLE