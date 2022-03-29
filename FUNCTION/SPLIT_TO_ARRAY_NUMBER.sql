
  CREATE OR REPLACE FUNCTION "SPLIT_TO_ARRAY_NUMBER" (input_list varchar2, delimiter varchar2)
return dbms_sql.number_table
is
	v_list varchar2(32767) :=  input_list || delimiter;
	l_index PLS_INTEGER := 1;
	l_comma_index number;
  number_values dbms_sql.number_table;
  string_values dbms_sql.varchar2_table;

begin
    LOOP
           l_comma_index := INSTR(v_list, delimiter, l_index);
           EXIT WHEN l_comma_index = 0;
           number_values(l_index) := TRIM(SUBSTR(v_list,l_index,l_comma_index - l_index));
           -- dbms_output.put_line(TRIM(SUBSTR(v_list,l_index,l_comma_index - l_index)));
           l_index := l_comma_index + 1;
           -- dbms_output.put_line(l_index);
    END LOOP;
return number_values;
end split_to_array_number;