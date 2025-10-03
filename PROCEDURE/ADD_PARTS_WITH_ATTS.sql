
  CREATE OR REPLACE EDITIONABLE PROCEDURE "ADD_PARTS_WITH_ATTS" as 

numCOLLOBJID number;
numDERIVEDCOLLID number;
j number;
ATTRIBUTE_ID number;
ATTRIBUTE_DETERMINER varchar2(50);
num number;
error_msg varchar2(1000);
ATTRIBUTE_DETERMINER_ID number;
ATTRIBUTE specimen_part_attribute.attribute_type%TYPE;
ATTRIBUTE_VALUE specimen_part_attribute.ATTRIBUTE_VALUE%TYPE;
ATTRIBUTE_UNITS specimen_part_attribute.ATTRIBUTE_UNITS%TYPE;
ATTRIBUTE_REMARKS specimen_part_attribute.ATTRIBUTE_REMARK%TYPE;
ATTRIBUTE_DATE specimen_part_attribute.DETERMINED_DATE%TYPE;
failed_validation exception;
numID number;
ERR_NUM NUMBER(5); 
err_msg VARCHAR2(513);  
debug varchar2(50);

cursor tempparts is 
select * from CF_TEMP_PARTS_WITH_ATT where collection_object_id is null;

begin

for c1_rec in tempparts loop
  begin
  debug :='1';
  numCOLLOBJID :=sq_collection_object_id.nextval;
  numID := c1_rec.ID;
  update CF_TEMP_PARTS_WITH_ATT set collection_object_id = numCOLLOBJID where ID = numID;
  
  select collection_object_id into numDERIVEDCOLLID from cataloged_item where cat_num = c1_rec.cat_num and collection_cde = c1_rec.collection_cde;
  debug :='2';
  insert into coll_object(collection_object_id, coll_object_type, entered_person_id, coll_object_entered_date, coll_obj_disposition, lot_count, condition)
  values(numCOLLOBJID, 'SP', 0, sysdate, c1_rec.part_disposition_1,c1_rec.part_lot_count_1,c1_rec.part_condition_1);
  debug :='3';
  insert into specimen_part(collection_object_id, derived_from_cat_item, part_name, preserve_method)
  values(numCOLLOBJID, numDERIVEDCOLLID, c1_rec.part_name_1, c1_rec.preserv_method_1);
  debug :='4';
  for j in 1 .. 2 LOOP
  debug := '5.' || j; 
    execute immediate 'select count(*) from CF_TEMP_PARTS_WITH_ATT where PART_1_ATT_NAME_' || j || ' is not null and 
        PART_1_ATT_VAL_' || j || ' is not null and collection_object_id = ' || numCOLLOBJID into num;
        ---dbms_output.put_line ('num: ' || num);
        if num = 1 then
          select sq_attribute_id.nextval into ATTRIBUTE_ID from dual;
          debug:= debug || ': det';
          execute immediate 'select part_1_att_detby_' || j || ' from CF_TEMP_PARTS_WITH_ATT where collection_object_id = ' || 
                numCOLLOBJID into ATTRIBUTE_DETERMINER;
                --dbms_output.put_line ('ATTRIBUTE_DETERMINER: ' || ATTRIBUTE_DETERMINER);
              if ATTRIBUTE_DETERMINER is not null then
                select count(distinct(agent_id)) into num from agent_name where agent_name = ATTRIBUTE_DETERMINER;
                if num = 0 then
                  error_msg := 'Bad part_1_att_detby_' || j;
                  raise failed_validation;
                end if;
                select distinct(agent_id) into ATTRIBUTE_DETERMINER_ID from agent_name where agent_name = ATTRIBUTE_DETERMINER;
              else
                ATTRIBUTE_DETERMINER_ID := null;
              end if;
              debug:= debug || ': values';
              execute immediate 'select part_1_att_name_' || j || 
                  ',part_1_att_val_' || j ||
                  /*',part_1_att_units_' || j ||*/
                  ',part_1_att_rem_' || j ||
                  ',part_1_att_madedate_' || j ||
                  ' from CF_TEMP_PARTS_WITH_ATT where collection_object_id = ' || numCOLLOBJID into
                  ATTRIBUTE,
                  ATTRIBUTE_VALUE,
                  /*ATTRIBUTE_UNITS,*/
                  ATTRIBUTE_REMARKS,
                  ATTRIBUTE_DATE;
              --dbms_output.put_line ('ATTRIBUTE: ' || ATTRIBUTE);
              --dbms_output.put_line ('ATTRIBUTE_VALUE: ' || ATTRIBUTE_VALUE);
              debug:= debug || ': insert';
              insert into specimen_part_attribute (
                PART_ATTRIBUTE_ID,
                COLLECTION_OBJECT_ID,
                DETERMINED_BY_AGENT_ID,
                ATTRIBUTE_TYPE,
                ATTRIBUTE_VALUE,
                ATTRIBUTE_UNITS,
                ATTRIBUTE_REMARK,
                DETERMINED_DATE) 
                values (
                ATTRIBUTE_ID,
                numCOLLOBJID,
                ATTRIBUTE_DETERMINER_ID,
                ATTRIBUTE,
                ATTRIBUTE_VALUE,
                ATTRIBUTE_UNITS,
                ATTRIBUTE_REMARKS,
                ATTRIBUTE_DATE);
                 --dbms_output.put_line('inserted attribute);
            end if;
          end loop;
      update CF_TEMP_PARTS_WITH_ATT set error='moved' WHERE ID=numID;
      EXCEPTION
  
      WHEN FAILED_VALIDATION THEN
       ROLLBACK;
       err_num := SQLCODE;
       err_msg := SUBSTR(SQLERRM, 1, 512);
       UPDATE CF_TEMP_PARTS_WITH_ATT SET error = err_num || ': ' || err_msg WHERE ID=numID;
       COMMIT;
  
       WHEN OTHERS THEN
       ROLLBACK;
       err_num := SQLCODE;
       err_msg := SUBSTR(SQLERRM, 1, 512);
       UPDATE CF_TEMP_PARTS_WITH_ATT SET error = debug || '; ' || err_num || ': ' || err_msg WHERE ID=numID;
       COMMIT;
    end;
    null;
  commit;
  end loop;
end;