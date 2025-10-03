
  CREATE OR REPLACE EDITIONABLE PROCEDURE "ADD_MISSING_SLIDE_TRAYS" AS

CURSOR C1 IS select sp.collection_object_id, sp.derived_from_cat_item, sp.part_name, sp.preserve_method,  
    lot_count, pc.barcode, regexp_substr(pc.barcode, 'Shared_slide-cab-[0-9]*_col-[0-9]*_tray-') trayroot, coll_object_remarks, co.coll_obj_disposition, co.condition, 
    regexp_substr(pc.barcode, '[0-9]*$') starttray, regexp_substr(coll_object_remarks, 'Series continues to tray ([0-9]*)',1,1,'i',1) endtray
from specimen_part sp, coll_object_remark cor, coll_object co, coll_obj_cont_hist ch, container c, container pc
where coll_object_remarks like '%Series continues to tray%'
and sp.collection_object_id = cor.collection_object_id
and sp.collection_object_id = co.collection_object_id
and sp.collection_object_id = ch.collection_object_id
and ch.container_id = c.container_id
and c.parent_container_id = pc.container_id;

origcollobjid number;
newcollobjid number;
derivedfromid number;
starttray number;
endtray number;
numToAdd number;
newTray number;
containerid number;
parentcontainerid number;

BEGIN
/*for c1_rec in c1 loop

origcollobjid := c1_rec.collection_object_id;
derivedfromid := c1_rec.derived_from_cat_item;
starttray:=c1_rec.starttray;
endtray:=c1_rec.endtray;

numToAdd := endtray - starttray;
---DBMS_OUTPUT.PUT_LINE(C1_REC.coll_object_remarks || ': ' || C1_REC.BARCODE);

    for cntr in 1..numToAdd LOOP
    newTray := starttray + cntr;
---    DBMS_OUTPUT.PUT_LINE('ADDING: ' || c1_rec.trayroot || newTray);

newcollobjid :=  sq_collection_object_id.nextval;
 ---INSERT COLL_OBJECT       
        INSERT INTO coll_object (
			COLLECTION_OBJECT_ID,
			COLL_OBJECT_TYPE,
			ENTERED_PERSON_ID,
			COLL_OBJECT_ENTERED_DATE,
			LAST_EDITED_PERSON_ID,
			COLL_OBJ_DISPOSITION,
			LOT_COUNT_MODIFIER,
			LOT_COUNT,
			CONDITION,
			FLAGS )
		VALUES (
			newcollobjid,
			'SP',
			0,
			sysdate,
			0,
			C1_REC.coll_obj_disposition,
			NULL,
			1,
			C1_REC.condition,
			0 );


---insert part
            INSERT INTO specimen_part (
			  collection_object_id,
			  PART_NAME,
			  preserve_method,
			DERIVED_FROM_cat_item)
			VALUES (
				newcollobjid,
                c1_rec.part_name,
                c1_rec.preserve_method,
                derivedfromid);

---insert remarks

            INSERT INTO coll_object_remark (collection_object_id, coll_object_remarks)
            VALUES (newcollobjid, 'This part added to represent the specimen in this container. Count not necessarily accurate.');

---put in container

            select container_id into containerid from coll_obj_cont_hist where collection_object_id = newcollobjid;
            select container_id into parentcontainerid from container where barcode = c1_rec.trayroot || newTray;
            update container set parent_container_id = parentcontainerid where container_id = containerid;

---copy attributes

            insert into specimen_part_attribute(collection_object_id, attribute_type, attribute_value, attribute_units, determined_date, determined_by_agent_id, attribute_remark)
            select newcollobjid, attribute_type, attribute_value, attribute_units, determined_date, determined_by_agent_id, attribute_remark from specimen_part_attribute where collection_object_id = origcollobjid;





    END LOOP;
---update original remarks
    update coll_object_remark set coll_object_remarks = regexp_replace(coll_object_remarks, '\|\| Series continues to tray .*$', '') where collection_object_id = origcollobjid;

---update original lot count
    update coll_object set lot_count = lot_count - numToAdd where collection_object_id = origcollobjid;
end loop;*/
NULL;
END;