
  CREATE OR REPLACE FUNCTION "GET_NUMBER_FOR_FIRST_AUTHOR" 
(
  PUBLICATION_ID IN NUMBER 
) RETURN NUMBER AS 
    TYPE rc IS REF CURSOR;
	query_cur	rc;
    retval number;
BEGIN
    open query_cur for '
   select min(author_position) from publication_author_name 
   where publication_id = :x
   ' using publication_id;
   
   	LOOP 
		FETCH  query_cur INTO retval;
		IF query_cur%notfound THEN
			EXIT;
		END IF;
	END LOOP;
   
   return retval;
   
END GET_NUMBER_FOR_FIRST_AUTHOR;