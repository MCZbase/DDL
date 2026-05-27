
  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_ANNOTATIONS_VALIDATE_TARGET" 
FOR INSERT OR UPDATE OF TARGET_TABLE, TARGET_PRIMARY_KEY, ANNOTATION_ID
ON MCZBASE.ANNOTATIONS
COMPOUND TRIGGER

	TYPE t_check_rec IS RECORD (
		annotation_id annotations.annotation_id%TYPE,
		target_table annotations.target_table%TYPE,
		target_primary_key annotations.target_primary_key%TYPE
	);

	TYPE t_check_tab IS TABLE OF t_check_rec INDEX BY PLS_INTEGER;
	g_rows_to_check t_check_tab;
	g_row_count NUMBER := 0;

	BEFORE EACH ROW IS
		v_exists NUMBER := 0;
		v_pk_column CTANNOTATION_TARGET_TABLE.PRIMARY_KEY_COLUMN%TYPE;
		v_sql VARCHAR2(4000);
	BEGIN
		IF :NEW.TARGET_TABLE IS NULL THEN
			RAISE_APPLICATION_ERROR(-20001, 'TARGET_TABLE is required.');
		END IF;

		IF :NEW.TARGET_PRIMARY_KEY IS NULL THEN
			RAISE_APPLICATION_ERROR(-20002, 'TARGET_PRIMARY_KEY is required.');
		END IF;

		SELECT PRIMARY_KEY_COLUMN
		INTO v_pk_column
		FROM MCZBASE.CTANNOTATION_TARGET_TABLE
		WHERE ANNOTATION_TARGET_TABLE = UPPER(:NEW.TARGET_TABLE);

		v_sql := 'SELECT COUNT(*) FROM MCZBASE.' ||
			DBMS_ASSERT.SQL_OBJECT_NAME(UPPER(:NEW.TARGET_TABLE)) ||
			' WHERE ' || DBMS_ASSERT.SIMPLE_SQL_NAME(v_pk_column) || ' = :1';

		EXECUTE IMMEDIATE v_sql INTO v_exists USING :NEW.TARGET_PRIMARY_KEY;

		IF v_exists = 0 THEN
			RAISE_APPLICATION_ERROR(
				-20003,
				'TARGET_PRIMARY_KEY ' || :NEW.TARGET_PRIMARY_KEY ||
				' does not exist in target table ' || UPPER(:NEW.TARGET_TABLE) || '.'
			);
		END IF;

		IF UPPER(:NEW.TARGET_TABLE) = 'ANNOTATIONS' THEN
			IF :NEW.ANNOTATION_ID = :NEW.TARGET_PRIMARY_KEY THEN
				RAISE_APPLICATION_ERROR(-20004, 'An annotation cannot target itself.');
			END IF;
		END IF;
	END BEFORE EACH ROW;

	AFTER EACH ROW IS
	BEGIN
		IF UPPER(:NEW.TARGET_TABLE) = 'ANNOTATIONS' THEN
			g_row_count := g_row_count + 1;
			g_rows_to_check(g_row_count).annotation_id := :NEW.ANNOTATION_ID;
			g_rows_to_check(g_row_count).target_table := :NEW.TARGET_TABLE;
			g_rows_to_check(g_row_count).target_primary_key := :NEW.TARGET_PRIMARY_KEY;
		END IF;
	END AFTER EACH ROW;

	AFTER STATEMENT IS
		v_cycle_count NUMBER;
		v_depth NUMBER;
		v_exists NUMBER;
	BEGIN
		FOR i IN 1 .. g_row_count LOOP
			/* referenced parent annotation must exist */
			SELECT COUNT(*)
			INTO v_exists
			FROM MCZBASE.ANNOTATIONS
			WHERE ANNOTATION_ID = g_rows_to_check(i).target_primary_key;

			IF v_exists = 0 THEN
				RAISE_APPLICATION_ERROR(-20005, 'Referenced parent annotation does not exist.');
			END IF;

			/* prevent broader cycles:
			   reject if proposed parent is already descended from this annotation */
			SELECT COUNT(*)
			INTO v_cycle_count
			FROM MCZBASE.ANNOTATIONS
			WHERE ANNOTATION_ID = g_rows_to_check(i).target_primary_key
			START WITH ANNOTATION_ID = g_rows_to_check(i).annotation_id
			CONNECT BY PRIOR TARGET_PRIMARY_KEY = ANNOTATION_ID
				AND PRIOR TARGET_TABLE = 'ANNOTATIONS';

			IF v_cycle_count > 0 THEN
				RAISE_APPLICATION_ERROR(-20006, 'Annotation relationship would create a cycle.');
			END IF;

			/* enforce max nesting depth <= 10
			   parent depth + new edge must not exceed 10 */
			SELECT NVL(MAX(LEVEL), 0)
			INTO v_depth
			FROM MCZBASE.ANNOTATIONS
			START WITH ANNOTATION_ID = g_rows_to_check(i).target_primary_key
			CONNECT BY PRIOR TARGET_PRIMARY_KEY = ANNOTATION_ID
				AND PRIOR TARGET_TABLE = 'ANNOTATIONS';

			IF v_depth + 1 > 10 THEN
				RAISE_APPLICATION_ERROR(-20007, 'Annotation nesting depth cannot exceed 10.');
			END IF;
		END LOOP;
	END AFTER STATEMENT;

END TRG_ANNOTATIONS_VALIDATE_TARGET;

ALTER TRIGGER "TRG_ANNOTATIONS_VALIDATE_TARGET" ENABLE