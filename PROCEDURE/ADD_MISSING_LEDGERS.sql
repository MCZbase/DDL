
  CREATE OR REPLACE EDITIONABLE PROCEDURE "ADD_MISSING_LEDGERS" (p_collection_cde IN varchar2, p_cat_num_prefix IN varchar2) 
as 

cursor c1 is
select cat_num_integer, collection_object_ID from mczbase.cataloged_item
where collection_cde = p_collection_cde
and collection_object_id not in 
(select related_primary_key from media_relations 
where media_relationship like '%ledger%')
and nvl(cat_num_prefix, 'X')=nvl(p_cat_num_prefix, 'X')
order by cat_num_integer asc;

numCollObjID number;
numCatNumInt number;
varIDSURN varchar2(50);
numScans number;
numMediaId number;
numMedia number;
dateScanDate date;
numVolumePage number(22);
varVolumeType VARCHAR2(255);
varVolumeName VARCHAR2(255); 
varCollection VARCHAR2(100);
varDepartment VARCHAR2(100);

begin
for c1_rec in c1 loop
numCatNumInt := c1_rec.cat_num_integer;
numCollObjID := c1_rec.collection_object_id;
varIDSURN := null;

select count(*) into numScans from  mczbase.ledgerscans_master where startnum <= numCatNumInt and endnum >= numCatNumInt  and collection_cde = p_collection_cde and nvl(cat_num_prefix, 1)=nvl(p_cat_num_prefix, 1);

If numScans = 1 then 
    select IDSURN into varIDSURN from mczbase.ledgerscans_master where startnum <= numCatNumInt and endnum >= numCatNumInt and collection_cde = p_collection_cde and nvl(cat_num_prefix, 1)=nvl(p_cat_num_prefix, 1);
    
    select count(*) into numMedia from mczbase.media where preview_uri = 'http://nrs.harvard.edu/' || varIDSURN || '?width=100';
    
    If numMedia = 0 then
    
        SELECT ScanDate,VolumePage, VolumeType, VolumeName, Collection, Department
        INTO dateScanDate,numVolumePage, varVolumeType, varVolumeName, varCollection, varDepartment
        FROM mczbase.ledgerscans_master
        where IDSURN = varIDSURN;
        
            INSERT INTO media(media_uri, media_type, mime_type, preview_uri)
                VALUES('http://nrs.harvard.edu/' || varIDSURN || '?buttons=y', 'image', 'image/jpeg', 'http://nrs.harvard.edu/' || varIDSURN || '?width=100')
                RETURNING media_id INTO numMediaId;

            INSERT INTO media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                VALUES(numMediaId, 'description', 'MCZ ' || varDepartment || ' ' || varCollection || ' ' || GET_TOKEN(varVolumeName, 2, '_') || '-' || GET_TOKEN(varVolumeName, 3, '_') || ', pg.' || numVolumePage, 0);

            INSERT INTO media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                VALUES(numMediaId, 'made date', dateScanDate, 0);
    End if;
    
    select media_id into numMediaId from mczbase.media where preview_uri = 'http://nrs.harvard.edu/' || varIDSURN || '?width=100';
    
    INSERT INTO mczbase.media_relations(media_id, media_relationship, created_by_agent_id, related_primary_key)
    VALUES(numMediaId, 'ledger entry for cataloged_item', 0, numCollObjId);
    commit;
end if;

numscans := null;
select count(*) into numScans from  mczbase.ledgerscans_master where instr(',' || catnums ||',', ',' || numCatNumInt ||',') > 0  and collection_cde = p_collection_cde and nvl(cat_num_prefix, 1)=nvl(p_cat_num_prefix, 1);

If numScans = 1 then 
    select IDSURN into varIDSURN from mczbase.ledgerscans_master where instr(',' || catnums ||',', ',' || numCatNumInt ||',') > 0 and collection_cde = p_collection_cde and nvl(cat_num_prefix, 1)=nvl(p_cat_num_prefix, 1);

    select count(*) into numMedia from mczbase.media where preview_uri = 'http://nrs.harvard.edu/' || varIDSURN || '?width=100';
    
    If numMedia = 0 then
    
        SELECT ScanDate,VolumePage, VolumeType, VolumeName, Collection, Department
        INTO dateScanDate,numVolumePage, varVolumeType, varVolumeName, varCollection, varDepartment
        FROM mczbase.ledgerscans_master
        where IDSURN = varIDSURN;

            INSERT INTO media(media_uri, media_type, mime_type, preview_uri)
                VALUES('http://nrs.harvard.edu/' || varIDSURN || '?buttons=y', 'image', 'image/jpeg', 'http://nrs.harvard.edu/' || varIDSURN || '?width=100')
                RETURNING media_id INTO numMediaId;

            INSERT INTO media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                VALUES(numMediaId, 'description', 'MCZ ' || varDepartment || ' ' || varCollection || ' ' || GET_TOKEN(varVolumeName, 2, '_') || '-' || GET_TOKEN(varVolumeName, 3, '_') || ', pg.' || numVolumePage, 0);

            INSERT INTO media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                VALUES(numMediaId, 'made date', dateScanDate, 0);
    End if;
    
    select media_id into numMediaId from mczbase.media where preview_uri = 'http://nrs.harvard.edu/' || varIDSURN || '?width=100';
    
    INSERT INTO mczbase.media_relations(media_id, media_relationship, created_by_agent_id, related_primary_key)
    VALUES(numMediaId, 'ledger entry for cataloged_item', 0, numCollObjId);
    commit;
end if;

end loop;

end;