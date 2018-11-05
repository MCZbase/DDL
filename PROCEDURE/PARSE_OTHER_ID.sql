
  CREATE OR REPLACE PROCEDURE "PARSE_OTHER_ID" (
	collection_object_id IN number,
	other_id_num IN varchar2,
	other_id_type IN varchar2)
IS
    part_one varchar2(255);
    part_two varchar2(255);
    part_three varchar2(255);
	dlms VARCHAR2(255) := '|-.; ';
	td VARCHAR2(255);
	pend_disp_val varchar2(255);
	part_two_number NUMBER;
BEGIN
	IF is_number(other_id_num) = 1 THEN -- just a number
	    part_one := NULL;
        part_two := other_id_num;
        part_three := NULL;
	 ELSIF -- number plus single char
	     is_number(substr(
	         other_id_num,
	         1,
	         length(other_id_num) - 1)) = 1
	     THEN
	          part_two := substr(
	             other_id_num,
	             1,
	             length(other_id_num) - 1);
	         part_three := substr(other_id_num,length(other_id_num));
	 ELSIF -- single char + number
	     is_positive_number(substr(
               other_id_num,
               2)) = 1 THEN
         part_one := substr(other_id_num,1,1);
         part_two := substr(
               other_id_num,
               2);
   ELSIF regexp_like(other_id_num, '^[^0-9]+[0-9]+[^0-9]*$') THEN
      part_one := regexp_substr(other_id_num, '^([^0-9]+)([0-9]+)([^0-9]*)$', 1,1,'i',1);
      part_two := regexp_substr(other_id_num, '^([^0-9]+)([0-9]+)([^0-9]*)$', 1,1,'i',2);
      part_three := regexp_substr(other_id_num, '^([^0-9]+)([0-9]+)([^0-9]*)$', 1,1,'i',3);
   ELSE -- loop through list of delimiter defined above and see what falls out
	   FOR i IN 1..100 LOOP
	      td := substr(dlms,i,1);
	      EXIT WHEN td IS NULL;
	      IF instr(other_id_num,td) > 0 THEN  -- see if our number contains the current delimiter
              part_one := get_str_el (
   	              other_id_num,
   	                td,
   	                1) || td;
	          part_two := get_str_el (
   	              other_id_num,
   	                td,
   	                2);
               IF instr(other_id_num,td,1,2) > 0 THEN
	              part_three := td || get_str_el (
   	                  other_id_num,
   	                    td,
   	                    3);
	           END IF;
	           IF part_three IS NULL THEN -- got back two parts, see if we can make one of them numeric
	               IF is_number(part_two) = 0 AND is_number(part_one) = 1 THEN
	                   part_three := part_two;
	                   part_two := part_one;
	                   part_one := NULL;
	               END IF;
	           END IF;
	      end IF;
       END LOOP;
	END IF;

IF is_number(part_two) !=1 THEN
    part_one := other_id_num;
    part_two := NULL;
    part_three := NULL;
END IF;

part_two_number:=part_two;
pend_disp_val:=part_one || part_two_number || part_three;

IF pend_disp_val IS NULL OR other_id_num != pend_disp_val THEN
    part_one := other_id_num;
    part_two := NULL;
    part_three := NULL;
END IF;

	INSERT INTO coll_obj_other_id_num (
		COLLECTION_OBJECT_ID,
		OTHER_ID_TYPE,
		OTHER_ID_PREFIX,
		OTHER_ID_NUMBER,
		OTHER_ID_SUFFIX
	) values (
		collection_object_id,
		other_id_type,
		part_one,
		part_two,
		part_three
	);
end;
 