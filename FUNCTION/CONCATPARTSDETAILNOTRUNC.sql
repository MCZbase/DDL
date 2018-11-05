
  CREATE OR REPLACE FUNCTION "CONCATPARTSDETAILNOTRUNC" ( collobjid in integer)
    return CLOB
    as
        tmp    varchar2(4000);
        ta     varchar2(4000);
        sep    varchar2(10);
        ts    VARCHAR2(2);
        ret_tmp VARCHAR2(10000); -- ADDED THIS LINE.
        ret    CLOB;
        tmp_pn varchar2(4000);
    begin
        FOR r IN (
            select
               specimen_part.collection_object_id,
               nvl2(preserve_method, part_name || ' (' || preserve_method || ')',part_name) part_name,
               condition,
               nvl2(lot_count_modifier, lot_count_modifier || lot_count, lot_count) lot_count,
               coll_obj_disposition,
               coll_object_remarks,
               nvl(p.barcode,'NO BARCODE') barcode
            FROM
               specimen_part,
               ctspecimen_part_list_order,
               coll_object,
               coll_object_remark,
               coll_obj_cont_hist,
               container c,
               container p
            where
               specimen_part.collection_object_id =  coll_object.collection_object_id AND
               specimen_part.collection_object_id =  coll_object_remark.collection_object_id (+) AND
               specimen_part.part_name =  ctspecimen_part_list_order.partname (+) and
               SAMPLED_FROM_OBJ_ID is NULL and
               specimen_part.collection_object_id=coll_obj_cont_hist.collection_object_id (+) AND
               coll_obj_cont_hist.container_id=c.container_id (+) AND
               c.parent_container_id=p.container_id (+) AND
               derived_from_cat_item = collobjid
            ORDER BY
               partname,
               part_name,
               preserve_method) loop                
               tmp := r.part_name || ' {' || r.lot_count || '; ' || r.coll_obj_disposition || '; ' || r.condition || '; ' || r.barcode;
               IF r.coll_object_remarks IS NOT NULL THEN
                  tmp := tmp || '; ' || r.coll_object_remarks;
               END IF;
               tmp := tmp || '}';
               ta := '';
               FOR a IN (SELECT
                           attribute_type,
                           attribute_value,
                           attribute_units
                       FROM
                           specimen_part_attribute
                       WHERE
                           collection_object_id=r.collection_object_id) LOOP
                   ta := ta || ts || A.attribute_type || ': ' || A.attribute_value;
                   ts := '; ';
                   IF A.attribute_units IS NOT NULL THEN
                       ta := ta || ' ' || a.attribute_units;
                   END IF;
               END LOOP;
               IF ta IS NOT NULL THEN
                   tmp := tmp || ' [' || ta || ']';
               END IF;
               ret_tmp := ret_tmp || sep || tmp;
               sep := chr(10);
       end loop;
       IF ret_tmp IS NULL THEN
            ret := ' ';
       /*ELSIF LENGTH(ret_tmp) > 4000 THEN -- ADDED THIS LINE
            ret := substr(ret_tmp, 1, 3925) || '}' || sep || ' *** THERE ARE ADDITIONAL PARTS THAT ARE NOT SHOWN HERE ***'; -- ADDED THIS LINE*/
        ELSE ret := ret_tmp;
        END IF;
       return ret;
   end;