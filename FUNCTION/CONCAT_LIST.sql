
  CREATE OR REPLACE FUNCTION "CONCAT_LIST" 
  ( lst IN number_list_t, separator varchar2)
  RETURN  VARCHAR2 IS
   ret                 varchar2(1000);
BEGIN
    FOR j IN 1..lst.LAST  LOOP
        ret := ret || separator || lst(j);
    END LOOP;

    RETURN ret;
END;