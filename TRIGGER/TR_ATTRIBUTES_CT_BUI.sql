
  CREATE OR REPLACE TRIGGER "TR_ATTRIBUTES_CT_BUI" 
BEFORE UPDATE OR INSERT ON attributes
FOR EACH ROW
DECLARE
    numrows number := 0;
    collectionCode varchar2(10);
    sqlString varchar2(4000);
    vct varchar2(255);
    uct varchar2(255);
    ctctColname varchar2(255);
    ctctCollCde number := 0;
    no_problem_go_away exception;
BEGIN
    SELECT collection.collection_cde INTO CollectionCode
    FROM collection, cataloged_item
    WHERE collection.collection_id = cataloged_item.collection_id
    AND cataloged_item.collection_object_id = :NEW.collection_object_id;
    SELECT COUNT(*) INTO numrows
    FROM ctattribute_type
    WHERE attribute_type = :NEW.attribute_type
    AND collection_cde =collectionCode;
    IF (numrows = 0 and :NEW.attribute_type <> 'storage') THEN
         raise_application_error(
            -20001,
            'Invalid attribute_type');
    END IF;
    SELECT COUNT(*) INTO numrows
    FROM ctattribute_code_tables
    WHERE attribute_type = :NEW.attribute_type;
    IF (numrows = 0) THEN
        IF :new.attribute_units IS NOT NULL THEN
             raise_application_error(
                -20001,
                'This attribute cannot have units');
        ELSE
            RAISE no_problem_go_away;
        END IF;
    END IF;
    SELECT upper(VALUE_CODE_TABLE),upper(UNITS_CODE_TABLE) INTO vct,uct
    FROM ctattribute_code_tables
    WHERE attribute_type = :NEW.attribute_type;
    IF (vct IS NOT NULL) THEN
        SELECT column_name INTO ctctColname
        FROM user_tab_columns
        WHERE upper(table_name) = vct
        AND upper(column_name) <> 'COLLECTION_CDE'
        AND upper(column_name) <> 'DESCRIPTION';
        SELECT COUNT(*) INTO ctctCollCde
        FROM user_tab_columns
        WHERE upper(table_name) = vct
        AND column_name='COLLECTION_CDE';
        IF (ctctCollCde = 1) THEN
            sqlString := 'SELECT count(*)  FROM ' || vct || ' WHERE ' || ctctColname || ' = ''' || :NEW.ATTRIBUTE_VALUE || ''' and collection_cde= ''' || collectionCode  || '''';
            EXECUTE IMMEDIATE sqlstring INTO numrows;
            IF (numrows = 0) THEN
                 raise_application_error(
                    -20001,
                    'Invalid ATTRIBUTE_VALUE for ATTRIBUTE_TYPE in this collection');
            END IF;
        ELSE
            sqlString := 'SELECT count(*)  FROM ' || vct || ' WHERE ' || ctctColname || ' = ''' || :NEW.ATTRIBUTE_VALUE || '''';
            EXECUTE IMMEDIATE sqlstring INTO numrows;
            IF (numrows = 0) THEN
                 raise_application_error(
                    -20001,
                    'Invalid ATTRIBUTE_VALUE for ATTRIBUTE_TYPE in this collection');
            END IF;
        END IF;
    ELSIF (uct is not null) THEN
        -- attributes with units must be numeric
        SELECT IS_number(REPLACE(replace(replace(:new.attribute_value, '-', ''), '.', ''), ' ', '')) INTO numrows FROM dual;
        IF numrows=0 THEN
             raise_application_error(
                -20001,
                'Attributes with units must be numeric');
        END IF;
        SELECT column_name INTO ctctColname
        FROM user_tab_columns
        WHERE upper(table_name) = uct
        AND upper(column_name) <>'COLLECTION_CDE'
        AND upper(column_name) <>'DESCRIPTION';
        sqlString := 'SELECT count(*)  FROM ' || uct || ' WHERE ' || ctctColname || ' = ''' || :NEW.ATTRIBUTE_UNITS || '''';
        EXECUTE IMMEDIATE sqlstring INTO numrows;
        IF (numrows = 0) THEN
             raise_application_error(
                -20001,
                'Invalid ATTRIBUTE_UNITS');
        END IF;
    END IF;
EXCEPTION
    WHEN no_problem_go_away THEN
        NULL;
END;
ALTER TRIGGER "TR_ATTRIBUTES_CT_BUI" ENABLE