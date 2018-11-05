
  CREATE OR REPLACE FUNCTION "IN_LIST" (p_in_list  IN  VARCHAR2)
  RETURN t_in_list_tab
AS
  l_tab   t_in_list_tab := t_in_list_tab();
  l_text  VARCHAR2(32767) := p_in_list || ',';
  l_idx   NUMBER;
BEGIN
  LOOP
    l_idx := INSTR(l_text, ',');
    EXIT WHEN NVL(l_idx, 0) = 0;
    l_tab.extend;
    l_tab(l_tab.last) := TRIM(SUBSTR(l_text, 1, l_idx - 1));
    l_text := SUBSTR(l_text, l_idx + 1);
  END LOOP;

  RETURN l_tab;
END;