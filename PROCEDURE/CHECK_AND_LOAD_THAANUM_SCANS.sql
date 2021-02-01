
  CREATE OR REPLACE PROCEDURE "CHECK_AND_LOAD_THAANUM_SCANS" AS

CURSOR c1 IS 
    SELECT ID FROM X_THAANUM_LEDGERS where moved is null or moved = 'X';
  

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
x VARCHAR2(50);
numSpecFound NUMBER;
l NUMBER;
numMedia number;
varMoved varchar2(1);
z number;
numLinksMissing number;
numID number;
varDebug varchar2(50);

BEGIN
execute immediate 'truncate table thaanum_notfound_master';
    varNumberType := 'DD Thaanum number';
    varCollectionCode := 'Mala';
varDebug := '46';    
    FOR c1_rec IN c1 LOOP
        numID := c1_rec.ID;

        SELECT
            IDS_URN, PDS_URN, PDS_Object_Id, to_date(Deposit_Date, 'MM/DD/YYYY'), 
            to_date(ScanDate, 'MM/DD/YYYY'),FileName, EndNum, 
            StartNum,cat_nums, Seq, Format, Volume_Title, Collection, Department, moved
        INTO
            varIDSURN, varPDSURN, numPDSObjectId, dateDepositDate, dateScanDate, 
            varFileName, numEndNum, numStartNum, varCatNums, numVolumePage, 
            varVolumeType, varVolumeName, varCollection, varDepartment, varMoved
        FROM X_THAANUM_LEDGERS
        WHERE ID=numID;
varDebug := '60';  
        BEGIN
          IF varmoved is null or varmoved = 'X' then
                        
            select count(*) into numMedia from media where media_uri =  'http://nrs.harvard.edu/' || varIDSURN || '?buttons=y';
            If numMedia =1 then 
              UPDATE X_THAANUM_LEDGERS set moved = 'Y', error = null where ID = numID;
            Else 
          
              INSERT INTO media(media_uri, media_type, mime_type, preview_uri)
                  VALUES('http://nrs.harvard.edu/' || varIDSURN || '?buttons=y', 'text', 'text/html', 'http://nrs.harvard.edu/' || varIDSURN || '?width=100')
                  RETURNING media_id INTO numMediaId;
  
              INSERT INTO media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                  VALUES(numMediaId, 'description', varVolumeName || ' - pg.' || numVolumePage, 0);
  
              INSERT INTO media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                  VALUES(numMediaId, 'made date', dateScanDate, 0);
                  
              UPDATE X_THAANUM_LEDGERS set moved = 'Y', error = null where  ID = numID;
              COMMIT;
            End if;
                
          END IF;
varDebug := '84';  
            IF numStartNum IS NULL AND numEndNum IS NULL THEN
varDebug := '86';              
                l := 1;
                ---numLinksMissing := 0;
                WHILE GET_TOKEN(varCatnums,l, ',') IS NOT NULL LOOP
                        x := TRIM(GET_TOKEN(varCatNums,l, ','));                    
                        SELECT COUNT(*) INTO numSpecFound 
                              FROM mczbase.COLL_OBJ_OTHER_ID_NUM, mczbase.cataloged_item
                              WHERE mczbase.COLL_OBJ_OTHER_ID_NUM.collection_object_id = mczbase.cataloged_item.collection_object_id
                              and display_value = x
                              and mczbase.cataloged_item.collection_cde = varCollectionCode
                              and mczbase.COLL_OBJ_OTHER_ID_NUM.other_id_type = varNumberType;
                              
                        IF numSpecFound > 0 THEN 
                              select media_id into numMediaId
                                    FROM MEDIA 
                                    where MEDIA_URI = 'http://nrs.harvard.edu/' || varIDSURN || '?buttons=y';
varDebug := '102 on ' || x;                                     
                              INSERT INTO media_relations(media_id, media_relationship, created_by_agent_id, related_primary_key)
                              SELECT DISTINCT numMediaId, 'ledger entry for cataloged_item', 0, mczbase.cataloged_item.collection_object_id 
                                from mczbase.COLL_OBJ_OTHER_ID_NUM, mczbase.cataloged_item
                                WHERE mczbase.COLL_OBJ_OTHER_ID_NUM.collection_object_id = mczbase.cataloged_item.collection_object_id
                                and display_value =  x
                                and mczbase.cataloged_item.collection_cde = varCollectionCode
                                and mczbase.COLL_OBJ_OTHER_ID_NUM.other_id_type = varNumberType
                                and mczbase.cataloged_item.collection_object_id not in
                                (select RELATED_PRIMARY_KEY from media_relations where media_id = numMediaId and media_relationship = 'ledger entry for cataloged_item');
                        ELSE
                            INSERT INTO thaanum_notfound_master(thaanum_number, media_id)
                                VALUES(x, numMediaId);
                        END IF;                                     
varDebug := '116 on ' || x;     
                l := l+1;
                END LOOP;
              ELSE
                  FOR x IN numStartNum..numEndNum LOOP
                      SELECT COUNT(*) INTO numSpecFound 
                            FROM mczbase.COLL_OBJ_OTHER_ID_NUM, mczbase.cataloged_item 
                            WHERE mczbase.COLL_OBJ_OTHER_ID_NUM.collection_object_id =  mczbase.cataloged_item.collection_object_id
                            and mczbase.cataloged_item.collection_cde = varCollectionCode
                            and mczbase.COLL_OBJ_OTHER_ID_NUM.other_id_type = varNumberType
                            AND COLL_OBJ_OTHER_ID_NUM.other_id_number = x;
                      
                       IF numSpecFound > 0 THEN 
                              select media_id into numMediaId
                                    FROM MEDIA 
                                    where MEDIA_URI = 'http://nrs.harvard.edu/' || varIDSURN || '?buttons=y';
                                    
                              INSERT INTO media_relations(media_id, media_relationship, created_by_agent_id, related_primary_key)
                              SELECT DISTINCT numMediaId, 'ledger entry for cataloged_item', 0, mczbase.cataloged_item.collection_object_id 
                                from mczbase.COLL_OBJ_OTHER_ID_NUM, mczbase.cataloged_item
                                WHERE mczbase.COLL_OBJ_OTHER_ID_NUM.collection_object_id = mczbase.cataloged_item.collection_object_id
                                and mczbase.COLL_OBJ_OTHER_ID_NUM.other_id_number  =  x
                                and mczbase.cataloged_item.collection_cde = varCollectionCode
                                and mczbase.COLL_OBJ_OTHER_ID_NUM.other_id_type = varNumberType
                                and mczbase.cataloged_item.collection_object_id not in
                                (select RELATED_PRIMARY_KEY from media_relations where media_id = numMediaId and media_relationship = 'ledger entry for cataloged_item');   
                        ELSE
                            INSERT INTO thaanum_notfound_master(thaanum_number, media_id)
                                VALUES(x, numMediaId);
                        END IF;
                  END LOOP;
            END IF;
            
            COMMIT;
    
        EXCEPTION

            WHEN OTHERS THEN ROLLBACK;
            err_num := SQLCODE;
            err_msg := SUBSTR(SQLERRM, 1, 512);
            UPDATE X_THAANUM_LEDGERS SET moved='X', ERROR = err_num || ':'|| err_msg || ' at line ' || varDebug WHERE ID = numID;
            COMMIT;
        
        END;

        NULL;
    END LOOP;

EXCEPTION

    WHEN OTHERS THEN ROLLBACK;
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 512);
    UPDATE X_THAANUM_LEDGERS SET moved='X', ERROR = err_num || ':'|| err_msg || ' at line ' || varDebug WHERE  ID = numID;
    COMMIT;
    
END;