
  CREATE OR REPLACE PROCEDURE "CHECK_LEDGER_SCANS" AS

CURSOR c1 IS 
    SELECT ID,IDSObjectId, collection_cde FROM LEDGERSCANS_MASTER where collection_cde = 'Ent' and COLLECTION = 'Ants';

err_num NUMBER(5); 
err_msg VARCHAR2(513);

varIDSURN VARCHAR2(255);
numIDSObjectId NUMBER(22);
varPDSURN VARCHAR2(255);
numPDSObjectId NUMBER(22);
dateDepositDate DATE;
dateScanDate DATE;
varFileName VARCHAR2(255);
varCatNums VARCHAR2(1000);
numEndNum NUMBER(22);
numStartNum NUMBER(22);
numVolumePage NUMBER(22);
varVolumeType VARCHAR2(255);
varVolumeName VARCHAR2(255);
varCollection VARCHAR2(100);
varDepartment VARCHAR2(100);
varCatSuffix VARCHAR2(5);
varNumberType VARCHAR2(50); 

numMediaId NUMBER;
varCollectionCode VARCHAR2(10);
varCatPref VARCHAR2(10);
numCollObjId NUMBER;
x NUMBER;
numSpecFound NUMBER;
l NUMBER;
numMedia number;
varMoved varchar2(1);
z number;
numLinksMissing number;
numID number;

BEGIN

    FOR c1_rec IN c1 LOOP
        numIDSObjectId := c1_rec.IDSObjectId;
        varCollectionCode := c1_rec.collection_cde;
        numID := c1_rec.ID;

        SELECT
            IDSURN, PDSURN, PDSObjectId, DepositDate, 
            ScanDate, FileName, CatNums, EndNum, 
            StartNum, VolumePage, VolumeType, VolumeName, Collection, Department, moved, collection_cde, cat_num_prefix, idnumber_type
        INTO
            varIDSURN, varPDSURN, numPDSObjectId, dateDepositDate, dateScanDate, 
            varFileName, varCatNums, numEndNum, numStartNum, numVolumePage, 
            varVolumeType, varVolumeName, varCollection, varDepartment, varMoved, varCollectionCode, varCatPref, varNumberType
        FROM ledgerscans_master
        WHERE IDSObjectId = numIDSObjectId
        and collection_cde = varCollectionCode
        and ID=numID;

        BEGIN
          IF varmoved is null or varmoved = 'X' then
          
            select count(*) into numMedia from media where media_uri =  'http://nrs.harvard.edu/' || varIDSURN || '?buttons=y';
            
            If numMedia = 0 then
              update LEDGERSCANS_MASTER set moved = 'X' where IDSObjectId = numIDSObjectId and ID = numID;
            elsif numMedia = 1 then
              update LEDGERSCANS_MASTER set moved = 'Y' where IDSObjectId = numIDSObjectId and ID = numID;
              /*INSERT INTO media(media_uri, media_type, mime_type, preview_uri)
                  VALUES('http://nrs.harvard.edu/' || varIDSURN || '?buttons=y', 'image', 'image/jpeg', 'http://nrs.harvard.edu/' || varIDSURN || '?width=100')
                  RETURNING media_id INTO numMediaId;
  
              INSERT INTO media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                  VALUES(numMediaId, 'description', 'MCZ ' || varDepartment || ' ' || varCollection || ' ' || GET_TOKEN(varVolumeName, 2, '_') || '-' || GET_TOKEN(varVolumeName, 3, '_') || ', pg.' || numVolumePage, 0);
  
              INSERT INTO media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                  VALUES(numMediaId, 'made date', dateScanDate, 0);
                  
              UPDATE LEDGERSCANS_MASTER set moved = 'Y', error = null where IDSObjectId = numIDSObjectId and ID = numID;
              COMMIT;*/
            End if;
                
          END IF;

            IF numStartNum IS NULL AND numEndNum IS NULL THEN
                l := 1;
                numLinksMissing := 0;
                WHILE GET_TOKEN(varCatnums,l, ',') IS NOT NULL LOOP
                    varCatSuffix := NULL;
                    IF REGEXP_LIKE(GET_TOKEN(varCatNums,l, ','), '[A-Za-z]') and not REGEXP_LIKE(GET_TOKEN(varCatNums,l, ','), '[\-]') THEN 
                        x := SUBSTR(TRIM(GET_TOKEN(varCatNums,l, ',')), 0, LENGTH(TRIM(GET_TOKEN(varCatNums,l, ',')))-1);
                        varCatSuffix := SUBSTR(TRIM(GET_TOKEN(varCatNums,l, ',')),LENGTH(TRIM(GET_TOKEN(varCatNums,l, ','))));
                    ELSIF REGEXP_LIKE(GET_TOKEN(varCatNums,l, ','), '[\-]') THEN
                        x := REGEXP_SUBSTR(TRIM(GET_TOKEN(varCatNums,l, ',')),'^(.*)(-)(.*)$',1,1,'i',1);
                        varCatSuffix := REGEXP_SUBSTR(TRIM(GET_TOKEN(varCatNums,l, ',')),'^(.*)(-.*)$',1,1,'i',2);
                    ELSE
                        varCatSuffix := NULL;
                        x := TRIM(GET_TOKEN(varCatNums,l, ','));
                    END IF;
---CATALOG NUMBERS
                    IF varNumberType = 'catalog number' then 
                          SELECT COUNT(*) INTO numSpecFound 
                              FROM mczbase.cataloged_item 
                              WHERE cat_num_integer = x 
                              AND collection_cde = varCollectionCode 
                              AND nvl(cat_num_prefix, 'XXXX')=nvl(varCatPref, 'XXXX')
                              AND nvl(cat_num_suffix, 'XXXX')=nvl(varCatSuffix, 'XXXX');
                          IF numSpecFound = 1 THEN
                          
                              SELECT collection_object_id INTO numCollObjId 
                                  FROM mczbase.cataloged_item 
                                  WHERE cat_num_integer = x 
                                  AND collection_cde = varCollectionCode
                                  AND nvl(cat_num_prefix, 'XXXX')=nvl(varCatPref, 'XXXX')
                                  AND nvl(cat_num_suffix, 'XXXX')=nvl(varCatSuffix, 'XXXX');
                                  
                              SELECT COUNT(*) into z
                                FROM MEDIA M, MEDIA_RELATIONS MR 
                                where M.MEDIA_ID = MR.MEDIA_ID 
                                and MR.MEDIA_RELATIONSHIP = 'ledger entry for cataloged_item' and MR.RELATED_PRIMARY_KEY = numCollObjId
                                and M.MEDIA_URI = 'http://nrs.harvard.edu/' || varIDSURN || '?buttons=y';
                              
                              IF z=0 then 
                                numLinksMissing := numLinksMissing +1;
                              END IF;
                          ELSE
                              numLinksMissing := numLinksMissing +1;
                          END IF; 
---otherIDs 
                    ELSE
                        SELECT COUNT(*) INTO numSpecFound 
                              FROM mczbase.COLL_OBJ_OTHER_ID_NUM, mczbase.cataloged_item
                              WHERE mczbase.COLL_OBJ_OTHER_ID_NUM.collection_object_id = mczbase.cataloged_item.collection_object_id
                              and display_value = varCatPref || x
                              and mczbase.cataloged_item.collection_cde = varCollectionCode
                              and mczbase.COLL_OBJ_OTHER_ID_NUM.other_id_type = varNumberType;
                              
                        IF numSpecFound > 0 THEN 
                            SELECT COUNT(*) into z
                                FROM MEDIA M, MEDIA_RELATIONS MR 
                                where M.MEDIA_ID = MR.MEDIA_ID 
                                and MR.MEDIA_RELATIONSHIP = 'ledger entry for cataloged_item' 
                                and M.MEDIA_URI = 'http://nrs.harvard.edu/' || varIDSURN || '?buttons=y'
                                and MR.RELATED_PRIMARY_KEY in
                                (SELECT mczbase.cataloged_item.COLLECTION_OBJECT_ID FROM mczbase.COLL_OBJ_OTHER_ID_NUM, mczbase.cataloged_item
                                    WHERE mczbase.COLL_OBJ_OTHER_ID_NUM.collection_object_id = mczbase.cataloged_item.collection_object_id
                                    and display_value = varCatPref || x
                                    and mczbase.cataloged_item.collection_cde = varCollectionCode);
                        numLinksMissing := numLinksMissing + (numSpecFound - z);
                        END IF;
                    END IF;                   
 
                l := l+1;
                END LOOP;
                update LEDGERSCANS_MASTER set missing_links = numLinksMissing where IDSObjectId = numIDSObjectId and ID = numID;
            ELSE
                   IF varNumberType = 'catalog number' then  
                        SELECT COUNT(*) INTO numLinksMissing 
                            FROM mczbase.cataloged_item 
                            WHERE nvl(cat_num_prefix, 'XXXX') = nvl(varCatPref, 'XXXX') 
                            AND cat_num_integer between numStartNum and numendnum 
                            AND collection_cde = varCollectionCode
                            and collection_object_id not in
                            (SELECT mr.related_primary_key
                                FROM MEDIA M, MEDIA_RELATIONS MR 
                                where M.MEDIA_ID = MR.MEDIA_ID 
                                and MR.MEDIA_RELATIONSHIP = 'ledger entry for cataloged_item'
                                and M.MEDIA_URI = 'http://nrs.harvard.edu/' || varIDSURN || '?buttons=y');
                  ELSE
                      SELECT COUNT(*) INTO numLinksMissing
                          FROM mczbase.COLL_OBJ_OTHER_ID_NUM, mczbase.cataloged_item
                          WHERE mczbase.COLL_OBJ_OTHER_ID_NUM.collection_object_id = mczbase.cataloged_item.collection_object_id
                              and mczbase.COLL_OBJ_OTHER_ID_NUM.other_id_prefix = varCatPref
                              and  mczbase.COLL_OBJ_OTHER_ID_NUM.other_id_number between numStartNum and numendnum 
                              and mczbase.cataloged_item.collection_cde = varCollectionCode
                              and mczbase.cataloged_item.collection_object_id not in
                            (SELECT mr.related_primary_key
                                FROM MEDIA M, MEDIA_RELATIONS MR 
                                where M.MEDIA_ID = MR.MEDIA_ID 
                                and MR.MEDIA_RELATIONSHIP = 'ledger entry for cataloged_item'
                                and M.MEDIA_URI = 'http://nrs.harvard.edu/' || varIDSURN || '?buttons=y');
                  End If;
                  
                        update LEDGERSCANS_MASTER set missing_links = numLinksMissing where IDSObjectId = numIDSObjectId and ID=numID;
            END IF;
    
        EXCEPTION

            WHEN OTHERS THEN ROLLBACK;
            err_num := SQLCODE;
            err_msg := SUBSTR(SQLERRM, 1, 512);
            UPDATE ledgerscans_master SET moved='X', ERROR = err_num || ':'|| err_msg WHERE  IDSObjectId = numIDSObjectId and ID=numID;
            COMMIT;
        
        END;
        COMMIT;
        NULL;
    END LOOP;

EXCEPTION

    WHEN OTHERS THEN ROLLBACK;
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 512);
    UPDATE ledgerscans_master SET moved='X', ERROR = err_num || ':'|| err_msg WHERE  IDSObjectId = numIDSObjectId and ID=numID;
    COMMIT;
    
END;