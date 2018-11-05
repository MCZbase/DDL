
  CREATE OR REPLACE FUNCTION "BULK_CHECK_ONE" (colobjid  in NUMBER)
return varchar2
as
 thisError varchar2(4000);
 numRecs NUMBER;
 attributeType varchar2(255);
 attributeValue varchar2(255);
  attributeUnits varchar2(255);
 attributeDate varchar2(255);
 attributeDeterminer varchar2(255);
 attributeValueTable varchar2(255);
 attributeUnitsTable varchar2(255);
  attributeCodeTableColName varchar2(255);
 partName  varchar2(255);
 preservMethod varchar2(255);
 partCondition  varchar2(255);
 partBarcode  varchar2(255);
 partContainerLabel  varchar2(255);
 partLotCountModifier  varchar2(255);
 partLotCount  varchar2(255);
 partDisposition  varchar2(255);
 otherIdType varchar2(255);
 otherIdNum varchar2(255);
 collectorName varchar2(255);
 collectorRole  varchar2(255);
 taxa_one varchar2(255);
 taxa_two varchar2(255);
 num number;
 tempStr VARCHAR2(255);
tempStr2 VARCHAR2(255);
collectionid NUMBER;
a_coln varchar2(255);
a_instn varchar2(255);
  BEGIN
        FOR rec IN (SELECT * FROM bulkloader where collection_object_id=colobjid ) LOOP
                BEGIN
                thisError := '';
                select count(distinct(agent_id)) into numRecs from agent_name where agent_name = rec.ENTEREDBY
                    AND agent_name_type != 'Kew abbr.';
                if (numRecs != 1) then
                        thisError :=  thisError || '; ENTEREDBY matches ' || numRecs || ' agents';
                END IF;
                select count(*) into numRecs from collection where
                                        institution_acronym = rec.institution_acronym and
                                        collection_cde=rec.collection_cde;
                IF (numRecs = 0) THEN
                        thisError :=  thisError || '; institution_acronym and/or collection_cde is invalid';
                END IF;
                IF (rec.cat_num is not null) THEN
                        select count(*) into numRecs from collection,cataloged_item where
                                collection.collection_id = cataloged_item.collection_id AND
                                collection.institution_acronym = rec.institution_acronym and
                                collection.collection_cde=rec.collection_cde AND
                                cat_num=rec.cat_num;
                        IF (numRecs > 0) THEN
                                thisError :=  thisError || '; cat_num is invalid';
                        END IF;
                END IF;
                IF (rec.cat_num = '0') THEN
                        thisError :=  thisError || '; cat_num may not be 0';
                END IF;
                IF (rec.relationship is not null) THEN
                        IF (rec.related_to_num_type is null OR rec.related_to_number is null) THEN
                                thisError :=  thisError || '; related_to_number and related_to_num_type are required when relationship is given';
                        END IF;
                        select count(*) into numRecs from ctbiol_relations where
                                biol_indiv_relationship =rec.relationship;
                        IF (numRecs = 0) THEN
                                thisError :=  thisError || '; relationship is invalid';
                        END IF;
                        select  count(*) into numRecs from ctcoll_other_id_type
                                where other_id_type=rec.related_to_num_type;
                        IF (numRecs = 0) AND rec.related_to_num_type != 'catalog number' THEN
                                thisError :=  thisError || '; related_to_num_type is invalid';
                        END IF;
                END IF;
                -- only care about collecting event, locality, and geog if we've not prepicked a collecting_event_id
                IF rec.collecting_event_id IS NULL THEN
                   IF rec.locality_id IS NULL THEN -- only care about locality if no event picked                       
                        SELECT count(*) INTO numRecs FROM geog_auth_rec WHERE higher_geog = rec.higher_geog;
                        IF (numRecs != 1) THEN
                                thisError :=  thisError || '; geog_auth_rec matched ' || numRecs || ' records';
                        END IF;
                        IF (isnumeric(rec.maximum_elevation) = 0) THEN
                                thisError :=  thisError || '; maximum_elevation is invalid';
                        END IF; 
                        IF (
                                (rec.maximum_elevation is not null AND rec.minimum_elevation is null) OR
                                (rec.minimum_elevation is not null AND rec.maximum_elevation is null) OR
                                ((rec.minimum_elevation is not null OR rec.maximum_elevation is not null) AND rec.orig_elev_units is null)
                                ) THEN
                                thisError :=  thisError || '; maximum_elevation,minimum_elevation,orig_elev_units are all required if one is given';
                        END IF; 
                        IF (rec.orig_elev_units is not null) THEN
                                SELECT count(*) INTO numRecs from ctorig_elev_units where orig_elev_units = rec.orig_elev_units;
                                IF (numRecs = 0) THEN
                                        thisError :=  thisError || '; orig_elev_units is invalid';
                                END IF;
                        END IF;
                        IF (rec.spec_locality is null) THEN
                                        thisError :=  thisError || '; spec_locality is required';
                                END IF;
                        IF (rec.min_depth is not null OR rec.max_depth is not null OR rec.depth_units is not null) AND
                                (isnumeric(rec.min_depth) = 0 OR isnumeric(rec.max_depth) = 0) THEN
                                thisError :=  thisError || '; depth is invalid';
                        END IF; 
                        IF (rec.depth_units is not null) THEN
                                SELECT count(*) INTO numRecs FROM ctdepth_units where depth_units=rec.depth_units;
                                IF (numRecs = 0) THEN
                                        thisError :=  thisError || '; depth_units is invalid';
                                END IF;
                                if rec.MIN_DEPTH is null or is_number(rec.MIN_DEPTH) = 0 OR rec.MAX_DEPTH is null or is_number(rec.MAX_DEPTH) = 0 then
                                        thisError :=  thisError || '; MIN_DEPTH and/or MAX_DEPTH is invalid';
                                END IF;
                        END IF;
                        IF (rec.orig_lat_long_units is NOT null) THEN
                                SELECT count(*) INTO numRecs from ctlat_long_units where orig_lat_long_units=rec.orig_lat_long_units;
                                IF (numRecs = 0) THEN
                                        thisError :=  thisError || '; orig_lat_long_units is invalid';
                                END IF;
                                
                                IF (rec.orig_lat_long_units = 'decimal degrees') THEN
                                        IF (isnumeric(rec.dec_lat) = 0 OR isnumeric(rec.dec_long) = 0  OR 
                                                rec.dec_long < -180 OR rec.dec_long > 180 OR rec.dec_lat < -90 OR rec.dec_lat > 90) THEN        
                                                thisError :=  thisError || '; dec_lat or dec_long is invalid';
                                        END IF;
                                ELSIF (rec.orig_lat_long_units = 'deg. min. sec.') THEN 
                                        IF (isnumeric(rec.latdeg) = 0 OR rec.latdeg < 0 OR rec.latdeg > 90 OR
                                                isnumeric(rec.latmin) = 0 OR rec.latmin < 0 OR rec.latmin > 60 OR
                                                isnumeric(rec.latsec) = 0 OR rec.latsec < 0 OR rec.latsec > 60 OR
                                                isnumeric(rec.longdeg) = 0 OR rec.longdeg < 0 OR rec.longdeg > 180 OR
                                                isnumeric(rec.longmin) = 0 OR rec.longmin < 0 OR rec.longmin > 60 OR
                                                isnumeric(rec.longsec) = 0 OR rec.longsec < 0 OR rec.longsec > 60) THEN
                                                thisError :=  thisError || '; coordinates are invalid';
                                        END IF;  
                                        IF (rec.latdir <> 'N' AND rec.latdir <> 'S') THEN
                                                thisError :=  thisError || '; latdir is invalid';
                                        END IF;
                                        IF (rec.longdir <> 'E' AND rec.longdir <> 'W') THEN
                                                thisError :=  thisError || '; longdir is invalid';
                                        END IF;
                                ELSIF (rec.orig_lat_long_units = 'degrees dec. minutes') THEN   
                                        IF (isnumeric(rec.latdeg) = 0 OR rec.latdeg < 0 OR rec.latdeg > 90 OR
                                                isnumeric(rec.dec_lat_min) = 0 OR rec.dec_lat_min < 0 OR rec.dec_lat_min > 60 OR
                                                isnumeric(rec.longdeg) = 0 OR rec.longdeg < 0 OR rec.longdeg > 180 OR
                                                isnumeric(rec.dec_long_min) = 0 OR rec.dec_long_min < 0 OR rec.dec_long_min > 60) THEN
                                                thisError :=  thisError || '; coordinates are invalid';
                                        END IF;                                 
                                        IF (rec.latdir != 'N' AND rec.latdir != 'S') THEN
                                                thisError := thisError || ' stuff broke at coordiantes';
                                        END IF;
                                        IF (rec.longdir <> 'E' AND rec.longdir <> 'W') THEN
                                                thisError :=  thisError || '; longdir is invalid';
                                        END IF;
                                ELSIF (rec.orig_lat_long_units = 'UTM') THEN
                                        IF isnumeric(rec.UTM_EW) = 0 OR isnumeric(rec.UTM_NS) = 0 THEN
                                                thisError := thisError || '; coordinates are invalid';
                                        END IF; 
                                END IF;
                                SELECT count(*) INTO numRecs from ctdatum where datum=rec.datum;
                                IF (numRecs = 0) THEN
                                        thisError :=  thisError || '; datum is invalid';
                                END IF;
                                SELECT count(distinct(agent_id)) INTO numRecs from agent_name where agent_name = rec.determined_by_agent
                                        and agent_name_type <> 'Kew abbr.';
                                IF (numRecs = 0) THEN
                                        thisError :=  thisError || '; determined_by_agent matches ' || numRecs || ' agents';
                                END IF;
                                IF (isdate(rec.determined_date)=0 OR rec.determined_date is null) THEN
                                        thisError :=  thisError || '; determined_date is invalid';
                                END IF;
                                IF (rec.lat_long_ref_source is null) THEN
                                        thisError :=  thisError || '; lat_long_ref_source is required';
                                END IF;
                                IF (rec.max_error_units is not null) THEN
                                        SELECT count(*) INTO numRecs from CTLAT_LONG_ERROR_UNITS where LAT_LONG_ERROR_UNITS = rec.max_error_units;
                                        IF (numRecs = 0) THEN
                                                thisError :=  thisError || '; max_error_units is invalid';
                                        END IF;
                                END IF;
                                SELECT count(*) INTO numRecs from CTGEOREFMETHOD where GEOREFMETHOD = rec.GEOREFMETHOD;
                                IF (numRecs = 0) THEN
                                        thisError :=  thisError || '; GEOREFMETHOD is invalid';
                                END IF;
                                SELECT count(*) INTO numRecs from CTVERIFICATIONSTATUS where VERIFICATIONSTATUS = rec.VERIFICATIONSTATUS;
                                IF (numRecs = 0) THEN
                                        thisError :=  thisError || '; VERIFICATIONSTATUS is invalid';
                                END IF; 
                        ELSE
                                If (rec.latdeg is not null or rec.longdeg is not null or rec.latmin is not null or rec.latsec is not null 
                                or rec.longmin is not null or rec.longsec is not null or rec.latdir is not null or rec.longdir is not null
                                or rec.dec_lat is not null or rec.dec_long is not null or rec.utm_ew is not null or rec.utm_ns is not null or rec.utm_zone is not null
                                or rec.DEC_LAT_MIN is not null or rec.DEC_LONG_MIN is not null) then 
                                  thisError :=  thisError || '; ORIG_LAT_LONG_UNITS cannot be null if Georef data is present';
                                End if;
                        END IF;  -- end lat/long check
                        ---------------------------------------------------- geol att ----------------------------------------------------              
                        for i IN 1..6 LOOP -- number of geol attributes
                                attributeValueTable := NULL;
                                attributeUnitsTable := NULL;
                        execute immediate 'select 
                                        geology_attribute_' || i || ',
                                        geo_att_value_' || i || ',
                                        geo_att_determined_date_' || i || ',
                                        geo_att_determiner_' || i || '
                                from bulkloader where  collection_object_id = ' || rec.collection_object_id into 
                                    attributeType,
                                        attributeValue,
                                        attributeDate,
                                        attributeDeterminer;
                                --- may need more checking later
                                IF attributeType is not null and attributeValue is not null THEN
                                        SELECT count(*) INTO numRecs FROM ctgeology_attribute WHERE geology_attribute = attributeType;
                                        IF (numRecs = 0) THEN
                                                thisError :=  thisError || '; geology_attribute_' || i || ' is invalid';
                                        END IF;
                                        if attributeDate is NOT null AND isdate(attributeDate)=0 then
                                                thisError:=thisError || '; geo_att_determined_date_' || i || ' is invalid';
                                        end if;
                                        IF attributeDeterminer IS NOT NULL THEN
                                            execute immediate 'select count(distinct(agent_id)) from agent_name where agent_name = ''' || attributeDeterminer ||'''' into numRecs;
                                                if numRecs = 0 then
                                                        thisError :=  thisError || '; geo_att_determiner_' || i || ' is invalid';
                                                end if;
                                        END IF;
                                END IF;
                        end loop; -- end geol attributes loop                           
                ELSE -- no event picked; locality IS picked
                    SELECT count(*) INTO numRecs FROM locality WHERE locality_id = rec.locality_id;
                        if numRecs = 0 then
                                thisError :=  thisError || '; locality_id is invalid';
                        END IF;
                END IF;  -- end locality_id check; event NOT picked
                IF (rec.verbatim_locality is null) THEN
                                thisError :=  thisError || '; verbatim_locality is required';
                        END IF;
                        SELECT count(*) INTO numRecs FROM ctCOLLECTING_SOURCE WHERE COLLECTING_SOURCE = rec.COLLECTING_SOURCE;
                        if numRecs = 0 then
                                thisError :=  thisError || '; COLLECTING_SOURCE is invalid';
                        END IF;
                        IF (is_iso8601(rec.began_date)!='valid' OR rec.began_date is null) THEN
                                thisError :=  thisError || '; began_date is invalid';
                        END IF;
                        IF (is_iso8601(rec.ended_date)!='valid' OR rec.ended_date is null) THEN
                                thisError :=  thisError || '; ended_date is invalid';
                        END IF;
                        IF (rec.verbatim_date is null) THEN
                                thisError :=  thisError || '; verbatim_date is invalid';
                        END IF;
                        IF rec.startDayOfYear is not null and (isnumeric(rec.startDayOfYear)=0 or rec.startDayOfYear < 1 or rec.startDayOfYear > 366)  THEN
                                thisError :=  thisError || '; startDayOfYear is invalid';
                        END IF;
                        IF rec.endDayOfYear is not null and (isnumeric(rec.endDayOfYear)=0 or rec.endDayOfYear < 1 or rec.endDayOfYear > 366)  THEN
                                thisError :=  thisError || '; endDayOfYear is invalid';
                        END IF;
            ELSE -- collecting_event_id is NOT null       
                    SELECT count(*) INTO numRecs FROM collecting_event WHERE collecting_event_id = rec.collecting_event_id;
                        if numRecs = 0 then
                                thisError :=  thisError || '; collecting_event_id is invalid';
                        END IF;
            END IF; -- end collecting_event_id/locality_id check
                IF length(rec.made_date) > 0 AND isdate(rec.made_date)=0 THEN
                        thisError :=  thisError || '; made_date is invalid';
                END IF;
                SELECT count(*) INTO numRecs from ctnature_of_id WHERE nature_of_id = rec.nature_of_id;
                IF (numRecs = 0) THEN
                        thisError :=  thisError || '; nature_of_id is invalid';
                END IF; 
                IF (rec.taxon_name is null) THEN
                        thisError :=  thisError || '; taxon_name is required';
                ELSE
                        if instr(rec.taxon_name,' or ') > 1 then
                                num := instr(rec.taxon_name, ' or ') -1;
                                taxa_one := substr(rec.taxon_name,1,num);
                                taxa_two := substr(rec.taxon_name,num+5);
                        elsif instr(rec.taxon_name,' and ') > 1 then
                                num := instr(rec.taxon_name, ' and ') -1;
                                taxa_one := substr(rec.taxon_name,1,num);
                                taxa_two := substr(rec.taxon_name,num+6);
                        elsif instr(rec.taxon_name,' x ') > 1 then
                                num := instr(rec.taxon_name, ' x ') -1;
                                taxa_one := substr(rec.taxon_name,1,num);
                                taxa_two := substr(rec.taxon_name,num+4);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 3) = ' sp.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 4);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' ssp.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 8) = ' sp. nov.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 9);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 9) = ' gen. nov.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 10);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 7) = ' (group)' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 8);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 3) = ' cf.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 4);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' aff.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 3) = ' nr.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 4);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 1) = ' ?' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 2);
                        elsif (instr(rec.taxon_name,' {') > 1 AND instr(rec.taxon_name,'}') > 1) then
                                taxa_one := regexp_replace(rec.taxon_name,' {.*}$','');
                        else
                                taxa_one := rec.taxon_name;
                        end if;                         
                        if taxa_two is not null AND (
                                  substr(taxa_one,length(taxa_one) - 3) = ' sp.' OR
                                        substr(taxa_two,length(taxa_two) - 3) = ' sp.' OR
                                        substr(taxa_one,length(taxa_one) - 1) = ' ?' OR
                                        substr(taxa_two,length(taxa_two) - 1) = ' ?' 
                                ) then
                                        thisError :=  thisError || '; "sp." and "?" are not allowed in multi-taxon IDs';
                        end if;
                        if taxa_one is not null then
                                select count(distinct(taxon_name_id)) into numRecs from taxonomy where scientific_name = trim(taxa_one) and VALID_CATALOG_TERM_FG = 1;
                                if numRecs = 0 then
                                        thisError :=  thisError || '; Taxonomy (' || taxa_one || ') not found';
                                end if;
                        end if;
                        if taxa_two is not null then
                                select count(distinct(taxon_name_id)) into numRecs from taxonomy where scientific_name = trim(taxa_two) and VALID_CATALOG_TERM_FG = 1;
                                if numRecs = 0 then
                                        thisError :=  thisError || '; Taxonomy (' || taxa_two || ') not found';
                                end if;
                        end if;
                END IF;
                SELECT count(distinct(agent_id)) INTO numRecs from agent_name where agent_name = rec.ID_MADE_BY_AGENT
                                and agent_name_type <> 'Kew abbr.';
                IF (numRecs = 0) THEN
                        thisError :=  thisError || '; ID_MADE_BY_AGENT matches ' || numRecs || ' agents';
                END IF;
                
                for i IN 1 .. 10 LOOP -- number of attributes
                        attributeValueTable := NULL;
                        attributeUnitsTable := NULL;
                        execute immediate 'select 
                                        ATTRIBUTE_' || i || ',
                                        ATTRIBUTE_VALUE_' || i || ',
                                        ATTRIBUTE_UNITS_' || i || ',
                                        ATTRIBUTE_DATE_' || i || ',
                                        ATTRIBUTE_DETERMINER_' || i || '
                                from bulkloader where  collection_object_id = ' || rec.collection_object_id into 
                                    attributeType,
                                    attributeValue,
                                    attributeUnits,
                                    attributeDate,
                                    attributeDeterminer;
                                IF attributeType is not null and attributeValue is not null THEN
                                        SELECT count(*) INTO numRecs FROM ctattribute_type WHERE ATTRIBUTE_TYPE = attributeType AND 
                                            collection_cde = rec.collection_cde;
                                        IF (numRecs = 0) THEN
                                                thisError :=  thisError || '; ATTRIBUTE_' || i || ' is invalid';
                                        END IF;
                                        execute immediate 'SELECT count(*) FROM ctattribute_code_tables WHERE ATTRIBUTE_TYPE = ''' || attributeType || '''' INTO numRecs;
                                        IF (numRecs > 0) THEN
                                                select VALUE_CODE_TABLE,UNITS_CODE_TABLE into attributeValueTable,attributeUnitsTable
                                                        FROM ctattribute_code_tables WHERE ATTRIBUTE_TYPE = attributeType;
                                                IF attributeValueTable is not null then
                                                        execute immediate 'select count(*) from user_tab_cols where table_name = ''' ||attributeValueTable || '''
                                                                and column_name=''COLLECTION_CDE''' into numRecs;
                                                        execute immediate 'select column_name from user_tab_cols where table_name = ''' ||upper(attributeValueTable) || '''
                                                                and column_name <> ''DESCRIPTION'' and column_name <> ''COLLECTION_CDE''' into attributeCodeTableColName;
                                                        if numRecs = 1 then
                                                                execute immediate 'select count(*) from ' || attributeValueTable || ' where ' || 
                                                                        attributeCodeTableColName || ' = ''' || attributeValue || ''' and collection_cde = ''' || 
                                                                        rec.collection_cde || '''' into numRecs;
                                                                if numRecs = 0 then
                                                                        thisError :=  thisError || '; ATTRIBUTE_' || i || ' value is not in the code table';
                                                                end if;
                                                        else
                                                                execute immediate 'select count(*) from ' || attributeValueTable || ' where ' || 
                                                                        attributeCodeTableColName || ' = ''' || attributeValue || '''' into numRecs;
                                                                if numRecs = 0 then
                                                                        thisError :=  thisError || '; ATTRIBUTE_' || i || ' value is not in the code table';
                                                                end if;
                                                        end if;
                                                elsif attributeUnitsTable  is not null then
                                                        execute immediate 'select count(*) from user_tab_cols where table_name = ''' || attributeUnitsTable || '''
                                                                and column_name=''COLLECTION_CDE''' into numRecs;
                                                        execute immediate 'select column_name from user_tab_cols where table_name = ''' ||upper(attributeUnitsTable) || '''
                                                                and column_name <> ''DESCRIPTION'' and column_name <> ''COLLECTION_CDE''' into attributeCodeTableColName;
                                                        if numRecs = 1 then
                                                                execute immediate 'select count(*) from ' || attributeUnitsTable || ' where ' || 
                                                                        attributeCodeTableColName || ' = ''' || attributeUnits || ''' and collection_cde = ''' || 
                                                                        rec.collection_cde || '''' into numRecs;
                                                                if numRecs = 0 then
                                                                        thisError :=  thisError || '; ATTRIBUTE_' || i || ' units is not in the code table';
                                                                end if;
                                                        else
                                                                execute immediate 'select count(*) from ' || attributeUnitsTable || ' where ' || 
                                                                        attributeCodeTableColName || ' = ''' || attributeUnits || '''' into numRecs;
                                                                if numRecs = 0 then
                                                                        thisError :=  thisError || '; ATTRIBUTE_' || i || ' units is not in the code table';
                                                                end if;
                                                        end if;
                                                END IF; 
                                        END IF;
                                        /*if attributeDate is null or isdate(attributeDate) =0 then
                                                thisError :=  thisError || '; ATTRIBUTE_DATE_' || i || ' is invalid';
                                        end if;
                                        execute immediate 'select count(distinct(agent_id)) from agent_name where agent_name = ''' || attributeDeterminer ||'''' into numRecs;
                                        if numRecs != 1 then
                                                thisError :=  thisError || '; ATTRIBUTE_DETERMINER_' || i || ' is invalid (' || numRecs || ' matches)';
                                        end if;*/
                                END IF;
                end loop; -- end attributes loop
                for i IN 1 .. 12 LOOP -- number of parts
                        partName := NULL;
                        preservMethod :=NULL;
                        partCondition := NULL;
                        partBarcode := NULL;
                        partContainerLabel := NULL;
                        partLotCountModifier := NULL;
                        partLotCount := NULL;
                        partDisposition := NULL;
                                 execute immediate 'select 
                                        PART_NAME_' || i || ',
                                        PRESERV_METHOD_' || i || ',
                                        PART_CONDITION_' || i || ',
                                        PART_CONTAINER_UNIQUE_ID_' || i || ',
                                        PART_CONTAINER_NAME_' || i || ',
                                        PART_LOT_CNT_MOD_' || i || ',
                                        PART_LOT_COUNT_' || i || ',
                                        PART_DISPOSITION_' || i || '
                                 from bulkloader where  collection_object_id = ' || rec.collection_object_id into 
                                         partName,
                                         preservMethod,
                                         partCondition,
                                         partBarcode,
                                         partContainerLabel,
                                         partLotCountModifier,
                                         partLotCount,
                                         partDisposition;
                        if partName is not null then
                                SELECT count(*) INTO numRecs FROM ctspecimen_part_name WHERE PART_NAME = partName AND 
                                        collection_cde = rec.collection_cde;
                                        IF (numRecs = 0) THEN
                                                thisError :=  thisError || '; PART_NAME_' || i || ' is invalid';
                                        END IF;
                                if preservMethod is null then 
                                  thisError :=  thisError || '; PRESERV_METHOD_' || i || ' is invalid';
                                else
                                  SELECT count(*) INTO numRecs FROM ctspecimen_preserv_method WHERE PRESERVE_METHOD = preservMethod AND 
                                        collection_cde = rec.collection_cde;
                                        IF (numRecs = 0) THEN
                                                thisError :=  thisError || '; PRESERV_METHOD_' || i || ' is invalid';
                                        END IF;
                                end if;
                                if partCondition is null then
                                        thisError :=  thisError || '; PART_CONDITION_' || i || ' is invalid';
                                END IF; 
                                if partBarcode is not null then
                                        SELECT count(*) INTO numRecs FROM container WHERE barcode = partBarcode;
                                        if numRecs = 0 then
                                                thisError :=  thisError || '; container_unique_id_' || i || ' is invalid';
                                        END IF;
                                        SELECT count(*) INTO numRecs FROM container WHERE container_type !='cryovial label' AND container_type LIKE '%label%' AND barcode = partBarcode;
                                        if numRecs != 0 then
                                                thisError :=  thisError || '; container_unique_id_' || i || ' is a label';
                                        END IF;
                                        --if partContainerLabel is null then
                                        --      thisError :=  thisError || '; PART_CONTAINER_LABEL_' || i || ' is invalid';
                                        --END IF;
                                else
                                        if partContainerLabel is not null then
                                                thisError :=  thisError || '; PART_CONTAINER_NAME_' || i || ' is invalid';
                                        END IF;
                                END IF;
                                if partLotCountModifier is not null then
                                  SELECT count(*) INTO numRecs FROM ctnumeric_modifiers WHERE modifier = partLotCountModifier;
                                        IF (numRecs = 0) THEN
                                                thisError :=  thisError || '; PART_LOT_CNT_MOD_' || i || ' is invalid';
                                        END IF;
                                end if;
                                if partLotCount is null or is_number(partLotCount) = 0 then
                                        thisError :=  thisError || '; PART_LOT_COUNT_' || i || ' is invalid';
                                END IF;
                                SELECT count(*) INTO numRecs FROM ctcoll_obj_disp WHERE partDisposition = partDisposition;
                                        if numRecs = 0 then
                                                thisError :=  thisError || '; PART_DISPOSITION_' || i || ' is invalid';
                                        END IF;
                                for j IN 1 .. 4 LOOP -- number of attributes
                                            attributeValueTable := NULL;
                                            attributeUnitsTable := NULL;
                                            execute immediate 'select 
                                                            part_' || i || '_att_name_' || j || ',
                                                            part_' || i || '_att_val_' || j || ',
                                                            part_' || i || '_att_units_' || j || ',
                                                            part_' || i || '_att_madedate_' || j || ',
                                                            part_' || i || '_att_detby_' || j || '
                                                    from bulkloader where  collection_object_id = ' || rec.collection_object_id into 
                                                        attributeType,
                                                        attributeValue,
                                                        attributeUnits,
                                                        attributeDate,
                                                        attributeDeterminer;
                                                    IF attributeType is not null and attributeValue is not null THEN
                                                            SELECT count(*) INTO numRecs FROM ctspecpart_attribute_type WHERE ATTRIBUTE_TYPE = attributeType;
                                                            IF (numRecs = 0) THEN
                                                                    thisError :=  thisError || '; PART_' || i || '_ATT_' || j || ' is invalid';
                                                            END IF;
                                                            execute immediate 'SELECT count(*) FROM ctattribute_code_tables WHERE ATTRIBUTE_TYPE = ''' || attributeType || '''' INTO numRecs;
                                                            IF (numRecs > 0) THEN
                                                                    select VALUE_CODE_TABLE,UNITS_CODE_TABLE into attributeValueTable,attributeUnitsTable
                                                                            FROM ctattribute_code_tables WHERE ATTRIBUTE_TYPE = attributeType;
                                                                    IF attributeValueTable is not null then
                                                                            execute immediate 'select count(*) from user_tab_cols where table_name = ''' ||attributeValueTable || '''
                                                                                    and column_name=''COLLECTION_CDE''' into numRecs;
                                                                            execute immediate 'select column_name from user_tab_cols where table_name = ''' ||upper(attributeValueTable) || '''
                                                                                    and column_name <> ''DESCRIPTION'' and column_name <> ''COLLECTION_CDE''' into attributeCodeTableColName;
                                                                            if numRecs = 1 then
                                                                                    execute immediate 'select count(*) from ' || attributeValueTable || ' where ' || 
                                                                                            attributeCodeTableColName || ' = ''' || attributeValue || ''' and collection_cde = ''' || 
                                                                                            rec.collection_cde || '''' into numRecs;
                                                                                    if numRecs = 0 then
                                                                                            thisError :=  thisError || '; PART_' || i || '_ATT_' || j || ' value is not in the code table';
                                                                                    end if;
                                                                            else
                                                                                    execute immediate 'select count(*) from ' || attributeValueTable || ' where ' || 
                                                                                            attributeCodeTableColName || ' = ''' || attributeValue || '''' into numRecs;
                                                                                    if numRecs = 0 then
                                                                                            thisError :=  thisError || '; PART_' || i || '_ATT_' || j || ' value is not in the code table';
                                                                                    end if;
                                                                            end if;
                                                                    elsif attributeUnitsTable  is not null then
                                                                            execute immediate 'select count(*) from user_tab_cols where table_name = ''' || attributeUnitsTable || '''
                                                                                    and column_name=''COLLECTION_CDE''' into numRecs;
                                                                            execute immediate 'select column_name from user_tab_cols where table_name = ''' ||upper(attributeUnitsTable) || '''
                                                                                    and column_name <> ''DESCRIPTION'' and column_name <> ''COLLECTION_CDE''' into attributeCodeTableColName;
                                                                            if numRecs = 1 then
                                                                                    execute immediate 'select count(*) from ' || attributeUnitsTable || ' where ' || 
                                                                                            attributeCodeTableColName || ' = ''' || attributeUnits || ''' and collection_cde = ''' || 
                                                                                            rec.collection_cde || '''' into numRecs;
                                                                                    if numRecs = 0 then
                                                                                            thisError :=  thisError || '; PART_' || i || '_ATT_' || j || ' units is not in the code table';
                                                                                    end if;
                                                                            else
                                                                                    execute immediate 'select count(*) from ' || attributeUnitsTable || ' where ' || 
                                                                                            attributeCodeTableColName || ' = ''' || attributeUnits || '''' into numRecs;
                                                                                    if numRecs = 0 then
                                                                                            thisError :=  thisError || '; PART_' || i || '_ATT_' || j || ' units is not in the code table';
                                                                                    end if;
                                                                            end if;
                                                                    END IF; 
                                                            END IF;
                                                            /*if attributeDate is null or isdate(attributeDate) =0 then
                                                                    thisError :=  thisError || '; ATTRIBUTE_DATE_' || i || ' is invalid';
                                                            end if;
                                                            execute immediate 'select count(distinct(agent_id)) from agent_name where agent_name = ''' || attributeDeterminer ||'''' into numRecs;
                                                            if numRecs != 1 then
                                                                    thisError :=  thisError || '; ATTRIBUTE_DETERMINER_' || i || ' is invalid (' || numRecs || ' matches)';
                                                            end if;*/
                                                    END IF;
                                    end loop; -- end attributes loop
                          END IF;
                end loop; -- end parts loop
                for i IN 1 .. 5 LOOP -- number of other IDs
                         execute immediate 'select 
                                        OTHER_ID_NUM_TYPE_' || i || ',
                                        OTHER_ID_NUM_' || i || '
                                 from bulkloader where  collection_object_id = ' || rec.collection_object_id into 
                                 otherIdType,
                                 otherIdNum;
                        if otherIdNum is not null then
                                if otherIdType is not null then
                                        SELECT count(*) INTO numRecs FROM ctcoll_other_id_type WHERE OTHER_ID_TYPE = otherIdType;
                                                if numRecs = 0 then
                                                        thisError :=  thisError || '; OTHER_ID_NUM_TYPE_' || i || ' (' || otherIdType || ') not found';
                                                END IF;
                                else
                                        thisError :=  thisError || '; OTHER_ID_NUM_TYPE_' || i || ' (' || otherIdType || ') is invalid';
                                end if;
                        end if;
                end loop; -- end other ID loop
                for i IN 1 .. 8 LOOP -- number of collectors
                         execute immediate 'select 
                                        COLLECTOR_AGENT_' || i || ',
                                        trim(COLLECTOR_ROLE_' || i || ')
                                 from bulkloader where  collection_object_id = ' || rec.collection_object_id into 
                                 collectorName,
                                 collectorRole;
                        if i = 1 and (collectorName is null or collectorRole != 'c') then
                                thisError :=  thisError || '; First collector is required';
                        end if;
                        if  collectorName is not null then
                                SELECT count(distinct(agent_id)) INTO numRecs FROM agent_name WHERE agent_name = collectorName;
                                        if numRecs = 0 then
                                                thisError :=  thisError || '; COLLECTOR_AGENT_' || i || ' is invalid';
                                        END IF;
                                if collectorRole not in ('c','p') then
                                        thisError :=  thisError || '; COLLECTOR_ROLE_' || i || ' is invalid';
                                end if;
                        end if;
                end loop; -- end collector loop
                if rec.flags is not null then
                        SELECT count(*) INTO numRecs FROM ctflags WHERE FLAGS = rec.FLAGS;
                        if numRecs = 0 then
                                thisError :=  thisError || '; FLAGS is invalid';
                        END IF; 
                end if;
              IF rec.accn LIKE '[%' AND rec.accn LIKE '%]%' THEN
                tempStr :=  substr(rec.accn, instr(rec.accn,'[',1,1) + 1,instr(rec.accn,']',1,1) -2);
                tempStr2 := REPLACE(rec.accn,'['||tempStr||']');
                tempStr:=REPLACE(tempStr,'[');
                tempStr:=REPLACE(tempStr,']');
                a_instn := substr(tempStr,1,instr(tempStr,':')-1);
                a_coln := substr(tempStr,instr(tempStr,':')+1);
              elsif regexp_like(rec.accn, '^[A-Za-z\-]*-[0-9]*$') then
                a_coln := regexp_substr(rec.accn, '^([A-Za-z\-]*)-([0-9]*)$',1,1,'i',1);
                a_instn := rec.institution_acronym;
                tempStr2 := regexp_substr(rec.accn, '^([A-Za-z\-]*)-([0-9]*)$',1,1,'i',2);
              ELSE
                -- use institution_acronym      
                a_coln := rec.collection_cde;
                a_instn := rec.institution_acronym;
                tempStr2 := rec.accn;
                END IF; 
            select count(distinct(accn.transaction_id)) into numRecs from 
            accn,trans,collection where 
                accn.transaction_id = trans.transaction_id and
                trans.collection_id=collection.collection_id AND
                collection.institution_acronym = a_instn and
                (collection.collection_cde = a_coln or collection.collection_cde = 'MCZ') AND
                accn_number = tempStr2;
                if numRecs = 0 then
                        thisError :=  thisError || '; ACCN is invalid';
                END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                        thisError := SQLERRM;
                END;
        END LOOP;
        RETURN thisError;
END;