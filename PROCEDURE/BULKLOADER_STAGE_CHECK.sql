
  CREATE OR REPLACE EDITIONABLE PROCEDURE "BULKLOADER_STAGE_CHECK" (staging_user in varchar2)
is
 thisError varchar2(4000);
 numRecs NUMBER;
 justAString varchar2(255);
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
  tempStr VARCHAR2(255);
tempStr2 VARCHAR2(255);
 taxa_one varchar2(255);
 taxa_two varchar2(255);
 num number;

  BEGIN
    dbms_output.put_line (staging_user);
    FOR rec IN (SELECT * FROM bulkloader_stage where staging_user = staging_user) LOOP
        if rec.staging_user = staging_user then
        dbms_output.put_line(rec.collection_object_id);
		thisError := '';
		select count(distinct(agent_id)) into numRecs from agent_name where agent_name_type='login' AND agent_name = rec.ENTEREDBY;
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
				thisError :=  thisError || '; cat_num already in MCZbase';
			END IF;
		END IF;
		IF (rec.cat_num = '0') THEN
			thisError :=  thisError || '; cat_num may not be 0';
		END IF;
    IF rec.collecting_event_id is null then 
      IF (isdate(rec.began_date)=0 OR rec.began_date is null) THEN
        thisError :=  thisError || '; began_date is invalid';
      END IF;
      IF (isdate(rec.ended_date)=0 OR rec.ended_date is null) THEN
        thisError :=  thisError || '; ended_date is invalid';
      END IF;
      IF (rec.verbatim_date is null) THEN
        thisError :=  thisError || '; verbatim_date is invalid';
      END IF;
      if rec.locality_id is null then 
          SELECT count(*) INTO numRecs FROM geog_auth_rec WHERE higher_geog = rec.higher_geog;
            IF (numRecs != 1) THEN
              thisError :=  thisError || '; geog_auth_rec matched ' || numRecs || ' records';
            END IF;
          IF (rec.spec_locality is null) THEN
            thisError :=  thisError || '; spec_locality is required';
          END IF;
      end if;
      IF (rec.verbatim_locality is null) THEN
        thisError :=  thisError || '; verbatim_locality is required';
      END IF;
      SELECT count(*) INTO numRecs FROM ctCOLLECTING_SOURCE WHERE COLLECTING_SOURCE = rec.COLLECTING_SOURCE;
        if numRecs = 0 then
          thisError :=  thisError || '; COLLECTING_SOURCE is invalid';
        END IF;
    end if;
		IF (rec.relationship is not null) THEN
			IF (rec.related_to_num_type is null OR rec.related_to_number is null) THEN
				thisError :=  thisError || '; ::related_to_number:: and ::related_to_num_type:: are required when relationship is given';
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
				IF (rec.latdir <> 'N' AND rec.latdir <> 'S') THEN
					thisError :=  thisError || '; latdir is invalid';
				END IF;
				IF (rec.longdir <> 'E' AND rec.longdir <> 'W') THEN
					thisError :=  thisError || '; longdir is invalid';
				END IF;
			END IF;
			SELECT count(*) INTO numRecs from ctdatum where datum =rec.datum;
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
			IF (isnumeric(rec.max_error_distance) = 0) THEN
				thisError :=  thisError || '; max_error_distance must be numeric';
			END IF;
			IF rec.max_error_units IS NOT NULL THEN
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
		END IF;
		IF (rec.made_date is NOT null AND isdate(rec.made_date)=0 ) THEN
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
                        elsif instr(rec.taxon_name,' near ') > 1 then
                                num := instr(rec.taxon_name, ' near ') -1;
                                taxa_one := substr(rec.taxon_name,1,num);
                                taxa_two := substr(rec.taxon_name,num+7);
                        elsif instr(rec.taxon_name,' x ') > 1 then
                                num := instr(rec.taxon_name, ' x ') -1;
                                taxa_one := substr(rec.taxon_name,1,num);
                                taxa_two := substr(rec.taxon_name,num+4);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 3) = ' sp.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 4);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' ssp.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' var.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 8) = ' sp. nov.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 9);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 9) = ' gen. nov.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 10);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 7) = ' (Group)' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 8);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 3) = ' cf.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 4);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' aff.' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);
                        elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' near' then
                                taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);
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
		IF (numRecs <> 1) THEN
			thisError :=  thisError || '; ID_MADE_BY_AGENT matches ' || numRecs || ' agents';
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
		for i IN 1 .. 10 LOOP -- number of attributes
			attributeValueTable := NULL;
			attributeUnitsTable := NULL;
			execute immediate 'select
					ATTRIBUTE_' || i || ',
					 ATTRIBUTE_VALUE_' || i || ',
					ATTRIBUTE_UNITS_' || i || ',
					 ATTRIBUTE_DATE_' || i || ',
					 ATTRIBUTE_DETERMINER_' || i || '
				 from bulkloader_stage where  collection_object_id = ' || rec.collection_object_id || ' and staging_user = ''' || rec.staging_user || ''''
                 into
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
					if attributeDate is not null then 
            if isdate(attributeDate) =0 then
              thisError :=  thisError || '; ATTRIBUTE_DATE_' || i || ' is invalid';
            end if;
          end if;
					if attributeDeterminer is not null then          
            select count(distinct(agent_id))  into numRecs from agent_name where agent_name =  attributeDeterminer;
            if numRecs = 0 then
              thisError :=  thisError || '; ATTRIBUTE_DETERMINER_' || i || ' is invalid';
            end if;
          end if;
				END IF;
		end loop; -- end attributes loop
		for i IN 1 .. 12 LOOP -- number of parts
			partName := NULL;
      preservMethod :=NULL;
			partCondition := NULL;
			partBarcode := NULL;
			partContainerLabel := NULL;
      partLotCountModifier :=  NULL;
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
				 from bulkloader_stage where  collection_object_id = ' || rec.collection_object_id || ' and staging_user = ''' || rec.staging_user || ''''
                 into
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
        END IF;
				if partCondition is null then
					thisError :=  thisError || '; PART_CONDITION_' || i || ' is invalid';
				END IF;
				if partBarcode is not null then
					SELECT count(*) INTO numRecs FROM container WHERE barcode = partBarcode;
					if numRecs = 0 then
						thisError :=  thisError || '; part_container_unique_id_' || i || ' is invalid';
					END IF;
					/*if partContainerLabel is null then
						thisError :=  thisError || '; PART_CONTAINER_NAME_' || i || ' is invalid';
					END IF;*/
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
        END IF;
				if partLotCount is null or is_number(partLotCount) = 0 then
					thisError :=  thisError || '; PART_LOT_COUNT_' || i || ' is invalid';
				END IF;
				SELECT count(*) INTO numRecs FROM ctcoll_obj_disp WHERE partDisposition = partDisposition;
					if numRecs = 0 then
						thisError :=  thisError || '; PART_DISPOSITION_' || i || ' is invalid';
					END IF;
			END IF;
		end loop; -- end parts loop
		for i IN 1 .. 5 LOOP -- number of other IDs
			 execute immediate 'select
					OTHER_ID_NUM_TYPE_' || i || ',
					OTHER_ID_NUM_' || i || '
				 from bulkloader_stage where  collection_object_id = ' || rec.collection_object_id || ' and staging_user = ''' || rec.staging_user || ''''
                 into
				 otherIdType,
				 otherIdNum;
			if otherIdNum is not null then
				if otherIdType is not null then
					SELECT count(*) INTO numRecs FROM ctcoll_other_id_type WHERE OTHER_ID_TYPE = otherIdType;
						if numRecs = 0 then
							thisError :=  thisError || '; OTHER_ID_TYPE_' || i || ' is invalid';
						END IF;
				else
					thisError :=  thisError || '; OTHER_ID_TYPE_' || i || ' is invalid';
				end if;
			end if;
 		end loop; -- end other ID loop
 		for i IN 1 .. 8 LOOP -- number of collectors
 			 execute immediate 'select
					COLLECTOR_AGENT_' || i || ',
					COLLECTOR_ROLE_' || i || '
				 from bulkloader_stage where  collection_object_id = ' || rec.collection_object_id || ' and staging_user = ''' || rec.staging_user || ''''
                 into
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
        	-- trans.institution in accn number
        	tempStr :=  substr(rec.accn, instr(rec.accn,'[',1,1) + 1,instr(rec.accn,']',1,1) -2);
        	tempStr2 := REPLACE(rec.accn,tempStr);
          ELSE
            -- use institution_acronym
            tempStr := rec.institution_acronym;
            tempStr2 := rec.accn;
    	END IF;
		SELECT count(*) INTO numRecs FROM accn WHERE ACCN_NUMBER = tempStr2;
		if numRecs = 0 then
			thisError :=  thisError || '; ACCN is invalid';
		END IF;


		if thisError is not null then
			if length(thisError) > 224 then
				thisError := substr(thisError,1,200) || ' {snip...}';
			end if;
			rollback;
			update bulkloader_stage set loaded = thisError where collection_object_id = rec.collection_object_id  and staging_user = rec.staging_user;
		end if;
		commit;
		dbms_output.put_line (rec.collection_object_id || ' staging_user = ' || staging_user ||': ' || thisError);
        end if;
	END LOOP;
END;

