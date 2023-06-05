
  CREATE OR REPLACE FUNCTION "GET_HABITAT" 
-- Given a collecting_event.collecting_event_id, returns the habitat_desc
-- as a varchar.
( collecting_event_id IN NUMBER
) RETURN VARCHAR2 
as
      type rc is ref cursor;
      retval    varchar2(4000);
      habitat_desc    varchar2(4000);
      l_cur    rc;
   begin
   retval := '';
   open l_cur for 'select habitat_desc from collecting_event where collecting_event_id = :x '
   using collecting_event_id;
       loop
           fetch l_cur into habitat_desc;
           exit when l_cur%notfound;
           retval := habitat_desc;
       end loop;
       close l_cur;

       return retval;
END;