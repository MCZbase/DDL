
  CREATE OR REPLACE PROCEDURE "BULK_LEP_IMAGES" is
  
  --  Copy image records from DataShot (lepidoptera schema) into MCZbase media records
--  for records that have had been brought to state specialist reviewed and then
--  successfully ingested into MCZbase via bulkloader_lepidoptera.  Since the DataShot
--  schema supports images, but the bulkloader does not, media records need
--  to be added separately.  
--  Progress of the full load is tracked in bulkloader_lepidoptera_map and in flags in 
--  the Specimen table.
  
  --cursors
  cursor c2 is select specimenid from bulkloader_lepidoptera_map where imagesloaded = 0;
  
  CURSOR c1(collobjid IN NUMBER) IS 
  select distinct * from images_for_load@lepidoptera where specimenid=collobjid;
  
  --variables
  mediaid mczbase.media.media_id%type;
  l_collection_object_id mczbase.coll_object.collection_object_id%type;
  numspecimenid bulkloader_lepidoptera_map.specimenid%type;
  err_num NUMBER(5);
  err_msg VARCHAR2(513);
  
  begin
  for c2_rec in c2 loop
    numspecimenid :=  c2_rec.specimenid;
    select distinct collection_object_id into l_collection_object_id from bulkloader_lepidoptera_map where specimenid = c2_rec.specimenid;
    
    begin
      For c1_rec in c1(c2_rec.specimenid) LOOP
        insert into media(media_uri, mime_type, media_type, preview_uri, media_license_id)
        values(c1_rec.media_uri, c1_rec.mime_type, c1_rec.media_type, regexp_replace(c1_rec.media_uri, '(^http://mczbase.mcz.harvard.edu/specimen_images/ent-[a-z]*/images/)(.*/)(.*)$', '\1\2thumbs/\3'),1)
        returning media_id into mediaid;
        
        insert into media_relations(media_id, media_relationship, created_by_agent_id, related_primary_key)
        values(mediaid, 'created by agent', 0, 0);
        
        insert into media_relations(media_id, media_relationship, created_by_agent_id, related_primary_key)
        values(mediaid, 'shows cataloged_item', 0, l_collection_object_id);
        
        insert into media_labels(media_id, media_label, label_value, assigned_by_agent_id)
        values(mediaid, 'made date', c1_rec.made_date, 0);
        
        insert into media_labels(media_id, media_label, label_value, assigned_by_agent_id)
        values(mediaid, 'subject', c1_rec.subject, 0);
        
        insert into media_keywords(media_id, keywords, lastdate)
        values(mediaid, c1_rec.keywords, sysdate);
        
        if c1_rec.md5sum is not null then 
             insert into media_labels(media_id, media_label, label_value, assigned_by_agent_id)
             values(mediaid, 'md5hash', c1_rec.md5sum, 0);
        end if;
        
      end loop;
    update bulkloader_lepidoptera_map set imagesloaded = 1 where specimenid = c2_rec.specimenid;
    commit;
    
    EXCEPTION
    when others then
      rollback;
      err_num := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 512);
      update bulkloader_lepidoptera_map set error='image error: ' || err_num || ':' || err_msg where specimenid = numspecimenid;
      commit;
    END;
  end loop;

EXCEPTION
	when others then
    rollback;
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 512);
		update bulkloader_lepidoptera_map set error='image error: ' || err_num || ':' || err_msg where specimenid = numspecimenid;
    commit;
END;