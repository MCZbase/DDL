
  CREATE OR REPLACE EDITIONABLE PROCEDURE "GENERATE_CODE_TABLE_DATA" AS
-- Export the content of each CT code table as a script of insert statements,
-- one file per table, in the CODE_TABLE_DATA directory, for the DDL repository.
-- Rows are ordered by every column so that unchanged tables produce identical files.
	CODE_TABLE_DIRECTORY CONSTANT VARCHAR2(30) := 'CODE_TABLE_DATA';
	TYPE t_type_list IS TABLE OF VARCHAR2(128) INDEX BY PLS_INTEGER;
	v_types t_type_list;
	v_column_count PLS_INTEGER;
	v_select_list VARCHAR2(32767);
	v_column_list VARCHAR2(32767);
	v_order_list VARCHAR2(32767);
	v_quoted_column VARCHAR2(130);
	v_cursor INTEGER;
	v_ignore INTEGER;
	v_value VARCHAR2(32767);
	v_file CLOB;
BEGIN
	FOR t IN (
		SELECT table_name
		FROM user_tables
		WHERE table_name LIKE 'CT%'
			AND temporary = 'N'
		ORDER BY table_name
	) LOOP
		v_types.DELETE;
		v_column_count := 0;
		v_select_list := NULL;
		v_column_list := NULL;
		v_order_list := NULL;
		FOR c IN (
			SELECT column_name, data_type
			FROM user_tab_columns
			WHERE table_name = t.table_name
			ORDER BY column_id
		) LOOP
			v_column_count := v_column_count + 1;
			v_types(v_column_count) := c.data_type;
			v_quoted_column := 't.' || DBMS_ASSERT.ENQUOTE_NAME(c.column_name, FALSE);
			IF v_column_count > 1 THEN
				v_select_list := v_select_list || ', ';
				v_column_list := v_column_list || ',';
				v_order_list := v_order_list || ', ';
			END IF;
			-- Convert in SQL with fixed formats, so the output doesn't depend on session NLS settings.
			IF c.data_type IN ('VARCHAR2', 'CHAR', 'NVARCHAR2', 'NCHAR') THEN
				v_select_list := v_select_list || v_quoted_column;
			ELSIF c.data_type IN ('NUMBER', 'FLOAT') THEN
				v_select_list := v_select_list || 'TO_CHAR(' || v_quoted_column || ',''TM9'',''NLS_NUMERIC_CHARACTERS=''''.,'''''')';
			ELSIF c.data_type = 'DATE' THEN
				v_select_list := v_select_list || 'TO_CHAR(' || v_quoted_column || ',''YYYY-MM-DD HH24:MI:SS'')';
			ELSE
				RAISE_APPLICATION_ERROR(-20001, 'Unsupported data type ' || c.data_type || ' in ' || t.table_name || '.' || c.column_name);
			END IF;
			v_column_list := v_column_list || c.column_name;
			v_order_list := v_order_list || v_quoted_column;
		END LOOP;

		-- SQLBLANKLINES because some descriptions contain blank lines, which otherwise end the statement in SQL*Plus.
		v_file := 'REM INSERTING into ' || t.table_name || CHR(10)
			|| 'SET DEFINE OFF;' || CHR(10)
			|| 'SET SQLBLANKLINES ON;' || CHR(10);

		v_cursor := DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(v_cursor,
			'SELECT ' || v_select_list
			|| ' FROM ' || DBMS_ASSERT.ENQUOTE_NAME(t.table_name, FALSE) || ' t'
			|| ' ORDER BY ' || v_order_list,
			DBMS_SQL.NATIVE);
		FOR i IN 1 .. v_column_count LOOP
			DBMS_SQL.DEFINE_COLUMN(v_cursor, i, v_value, 32767);
		END LOOP;
		v_ignore := DBMS_SQL.EXECUTE(v_cursor);
		WHILE DBMS_SQL.FETCH_ROWS(v_cursor) > 0 LOOP
			v_file := v_file || 'Insert into ' || t.table_name || ' (' || v_column_list || ') values (';
			FOR i IN 1 .. v_column_count LOOP
				DBMS_SQL.COLUMN_VALUE(v_cursor, i, v_value);
				IF i > 1 THEN
					v_file := v_file || ',';
				END IF;
				IF v_value IS NULL THEN
					v_file := v_file || 'null';
				ELSIF v_types(i) IN ('NUMBER', 'FLOAT') THEN
					v_file := v_file || v_value;
				ELSIF v_types(i) = 'DATE' THEN
					v_file := v_file || 'to_date(''' || v_value || ''',''YYYY-MM-DD HH24:MI:SS'')';
				ELSE
					v_file := v_file || '''' || REPLACE(v_value, '''', '''''') || '''';
				END IF;
			END LOOP;
			v_file := v_file || ');' || CHR(10);
		END LOOP;
		DBMS_SQL.CLOSE_CURSOR(v_cursor);

		DBMS_XSLPROCESSOR.CLOB2FILE(v_file, CODE_TABLE_DIRECTORY, t.table_name || '.sql');
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		IF v_cursor IS NOT NULL AND DBMS_SQL.IS_OPEN(v_cursor) THEN
			DBMS_SQL.CLOSE_CURSOR(v_cursor);
		END IF;
		RAISE;
END;
