
  CREATE OR REPLACE EDITIONABLE PROCEDURE "BULKLOADER_LOAD_RELATIONS" as

cursor c1 is
select * from cf_temp_relations where (fail_reason is null or fail_reason <> 'delete');

cnt number;
err varchar2(255);
tempID number;
failed_validation exception;
relatedCollObjId cataloged_item.collection_object_id%TYPE;
collObjId cataloged_item.collection_object_id%TYPE;
relType CF_TEMP_RELATIONS.RELATIONSHIP%type;
relNum CF_TEMP_RELATIONS.RELATED_TO_NUMBER%TYPE;
relRemarks CF_TEMP_RELATIONS.BIOL_INDIV_RELATION_REMARKS%TYPE;
numType CF_TEMP_RELATIONS.related_to_num_type%TYPE;
instACR COLLECTION.INSTITUTION_ACRONYM%TYPE;
catnum CATALOGED_ITEM.CAT_NUM%TYPE;
COLLCDE CATALOGED_ITEM.COLLECTION_CDE%TYPE;


err_num NUMBER(5);
err_msg VARCHAR2(249);

begin
for c1_rec in c1 loop
  tempID := c1_rec.CF_TEMP_RELATIONS_ID;
  collObjId := c1_rec.collection_object_id;
  relType := c1_rec.RELATIONSHIP;
  relNum :=c1_rec.RELATED_TO_NUMBER;
  relRemarks := c1_rec.BIOL_INDIV_RELATION_REMARKS;
  numType :=c1_rec.related_to_num_type;
  collCDE := null;
  catnum := null;
  
  
  begin
  if numType = 'catalog number' then
    collCDE := get_token(relNum, 2, ':');
    catNum := get_token(relNum, 3, ':');
    select count(*) into cnt from cataloged_item where collection_cde = collCDE and  cat_num = catNum;
    if cnt=0 then 
      err:='related cataloged_item (' || relNum || ')  not found';
      raise failed_validation;
    elsif cnt > 1 then 
      err:='multiple cataloged_items found';
      raise failed_validation;
    end if;
    
    select collection_object_id into relatedCollObjId from cataloged_item where collection_cde = collCDE and  cat_num = catNum;
    update CF_TEMP_RELATIONS set RELATED_COLLECTION_OBJECT_ID = relatedCollObjId where CF_TEMP_RELATIONS_ID = tempID;
    
    insert into biol_indiv_relations(COLLECTION_OBJECT_ID, RELATED_COLL_OBJECT_ID, BIOL_INDIV_RELATIONSHIP,BIOL_INDIV_RELATION_REMARKS)
    values(collObjId, relatedCollObjId, relType, relRemarks);
    
    update CF_TEMP_RELATIONS set fail_reason = 'delete' where CF_TEMP_RELATIONS_ID = tempID;
  else
    select count(*) into cnt from coll_obj_other_id_num where other_id_type = numType and display_value = relNum;
    if cnt=0 then 
      err:='related OTHER_ID_NUM (' || relType || ': ' || relNum || ') not found';
      raise failed_validation;
    elsif cnt > 1 then 
      err:='multiple OTHER_ID_NUMs (' || relType || ': ' || relNum || ')  found';
      raise failed_validation;
    end if;
    
    select collection_object_id into relatedCollObjId from coll_obj_other_id_num  where other_id_type = numType and display_value = relNum; 
    update CF_TEMP_RELATIONS set RELATED_COLLECTION_OBJECT_ID = relatedCollObjId where CF_TEMP_RELATIONS_ID = tempID;
    
    insert into biol_indiv_relations(COLLECTION_OBJECT_ID, RELATED_COLL_OBJECT_ID, BIOL_INDIV_RELATIONSHIP,BIOL_INDIV_RELATION_REMARKS)
    values(collObjId, relatedCollObjId, relType,relRemarks);
  end if;
  
  update cf_temp_relations set fail_reason = 'delete' where CF_TEMP_RELATIONS_ID = tempID;
  commit;
  
   EXCEPTION
    when failed_validation then 
      rollback;
      update cf_temp_relations set fail_reason=err, lasttrydate = SYSDATE where CF_TEMP_RELATIONS_ID = tempID;
      commit;
    when others then
      rollback;
      err_num := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 248);
      update cf_temp_relations set fail_reason= err_num || ': ' || err_msg, lasttrydate = SYSDATE where CF_TEMP_RELATIONS_ID = tempID;
      commit;
  END;
  end loop;
  EXCEPTION
      when failed_validation then 
        rollback;
        update cf_temp_relations set fail_reason=err, lasttrydate = SYSDATE where CF_TEMP_RELATIONS_ID = tempID;
        commit;
      when others then
        rollback;
        err_num := SQLCODE;
        err_msg := SUBSTR(SQLERRM, 1, 248);
        update cf_temp_relations set fail_reason= err_num || ': ' || err_msg, lasttrydate = SYSDATE where CF_TEMP_RELATIONS_ID = tempID;
        commit;
END;