
  CREATE OR REPLACE PACKAGE "BULK_PKG" as
	PROCEDURE check_and_load;
	PROCEDURE bulkloader_check;
END;
CREATE OR REPLACE PACKAGE BODY "BULK_PKG" as
error_msg varchar2(4000);
l_collection_object_id number;
l_collecting_event_id number;
l_entered_person_id number;
l_accn_id number;
l_taxa_formula varchar2(20);
l_id_made_by_agent_id number;
l_cat_num varchar2(255);
l_collection_id number;
l_locality_id number;
l_taxon_name_id_1 number;
l_taxon_name_id_2 number;
tempStr VARCHAR2(255);
tempStr2 VARCHAR2(255);
tempStr3 VARCHAR2(255);
failed_validation exception;
num number;
---------------------------------------------------------------------------------------------------------------------------------------------
 PROCEDURE bulkload_error  (
 	errMsg IN varchar,
 	sqlMsg IN varchar,
 	procName IN varchar,
 	collobjid IN number
 	) 
is
begin
	if sqlMsg != 'User-Defined Exception' then
		-- unhandled exception
		error_msg := errMsg || '; called from ' || procName || ': ' || sqlMsg;
	end if;
	if length(error_msg) > 224 then
		error_msg := substr(error_msg,1,200) || ' {snip...}';
	end if;
	update bulkloader set loaded = error_msg where collection_object_id = collobjid;
EXCEPTION
	when others then
		error_msg := 'An error in the error handler - OH NOES!! ' || error_msg;
		if length(error_msg) > 224 then
			error_msg := substr(error_msg,1,200) || ' {snip...}';
		end if;
		update bulkloader set loaded = error_msg where collection_object_id = collobjid;		
end;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE bulkloader_check 
is
 thisError varchar2(4000);
  BEGIN
	FOR rec IN (SELECT collection_object_id FROM bulkloader where loaded is null) LOOP
		SELECT bulk_check_one(rec.collection_object_id) INTO thisError FROM dual;
		if thisError is not null then
			if length(thisError) > 224 then
				thisError := substr(thisError,1,200) || ' {snip...}';
			end if;
			rollback;
			update bulkloader set loaded = thisError where collection_object_id = rec.collection_object_id;
		end if;
		commit;
	END LOOP;
END;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_rollback_bulkloader  (l_collection_object_id IN number,collobjid IN number) 
is
	determiner_id number;
	b_locality_id bulkloader.locality_id%TYPE;
	error_msg varchar2(4000);  
	b_container_id container.container_id%TYPE;
BEGIN
	delete from cf_temp_relations where collection_object_id = l_collection_object_id;
	delete from coll_obj_other_id_num where collection_object_id = l_collection_object_id;
  delete from specimen_part_attribute where collection_object_id in
    (select collection_object_id from specimen_part where derived_from_cat_item = l_collection_object_id);
  delete from coll_object_remark where collection_object_id in
    (select collection_object_id from specimen_part where derived_from_cat_item = l_collection_object_id);
	delete from specimen_part where derived_from_cat_item = l_collection_object_id;
	delete from attributes where collection_object_id = l_collection_object_id;
	delete from identification_agent where IDENTIFICATION_ID IN (
		select IDENTIFICATION_ID from IDENTIFICATION where collection_object_id = l_collection_object_id
	);
	delete from identification_taxonomy where IDENTIFICATION_ID IN (
		select IDENTIFICATION_ID from IDENTIFICATION where collection_object_id = l_collection_object_id
	);
	delete from identification_agent where IDENTIFICATION_ID IN (
		select IDENTIFICATION_ID from IDENTIFICATION where collection_object_id = l_collection_object_id
	);
	delete from IDENTIFICATION where collection_object_id = l_collection_object_id;
 	delete from collector where collection_object_id = l_collection_object_id;
	delete from cataloged_item where collection_object_id = l_collection_object_id;
  delete from coll_object_remark where collection_object_id = l_collection_object_id;
	--dbms_output.put_line('nuking coll_object ' || l_collection_object_id);
	delete from coll_object where collection_object_id = l_collection_object_id;	
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_bulk_this',collobjid);
END;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_bulkload_attribute  (collobjid IN number) 
is
catitemcollid cataloged_item.collection_object_id%TYPE;
DETERMINED_BY_AGENT_ID attributes.DETERMINED_BY_AGENT_ID%TYPE;
ATTRIBUTE attributes.attribute_type%TYPE;
ATTRIBUTE_VALUE attributes.ATTRIBUTE_VALUE%TYPE;
ATTRIBUTE_UNITS attributes.ATTRIBUTE_UNITS%TYPE;
ATTRIBUTE_REMARKS attributes.ATTRIBUTE_REMARK%TYPE;
ATTRIBUTE_DATE attributes.DETERMINED_DATE%TYPE;
ATTRIBUTE_DET_METH attributes.DETERMINATION_METHOD%TYPE;
ATTRIBUTE_DETERMINER_ID agent.agent_id%TYPE;
ATTRIBUTE_DETERMINER varchar2(255);
ATTRIBUTE_ID attributes.ATTRIBUTE_ID%TYPE;
BEGIN
	--dbms_output.put_line ('catitemcollid' || catitemcollid);
	for i IN 1 .. 14 LOOP -- number of attributes
		execute immediate 'select count(*) from bulkloader where ATTRIBUTE_' || i || ' is not null and 
			ATTRIBUTE_VALUE_' || i || ' is not null and collection_object_id = ' || collobjid into num;
		--dbms_output.put_line ('num: ' || num);
		if num = 1 then -- there's an attribute - insert it
			select sq_attribute_id.nextval into ATTRIBUTE_ID from dual;
			--dbms_output.put_line ('ATTRIBUTE_ID: ' || ATTRIBUTE_ID);
      execute immediate 'select ATTRIBUTE_DETERMINER_' || i || ' from bulkloader where collection_object_id = ' || 
				collobjid into ATTRIBUTE_DETERMINER;
				--dbms_output.put_line ('ATTRIBUTE_DETERMINER: ' || ATTRIBUTE_DETERMINER);
			if ATTRIBUTE_DETERMINER is null then
        ATTRIBUTE_DETERMINER := 'no agent';
				---error_msg := 'Bad ATTRIBUTE_DETERMINER_' || i;
				---raise failed_validation;
			end if;
			select count(distinct(agent_id)) into num from agent_name where agent_name = ATTRIBUTE_DETERMINER;
			if num = 0 then
				error_msg := 'Bad ATTRIBUTE_DETERMINER_' || i;
				raise failed_validation;
			end if;
			select distinct(agent_id) into ATTRIBUTE_DETERMINER_ID from agent_name where agent_name = ATTRIBUTE_DETERMINER;
			execute immediate 'select ATTRIBUTE_' || i || 
				',ATTRIBUTE_VALUE_' || i || 
				',ATTRIBUTE_UNITS_' || i || 
				',ATTRIBUTE_REMARKS_' || i ||
				',ATTRIBUTE_DATE_' || i ||
				',ATTRIBUTE_DET_METH_' || i || 
				' from bulkloader where collection_object_id = ' || collobjid into
				ATTRIBUTE,
				ATTRIBUTE_VALUE,
				ATTRIBUTE_UNITS,
				ATTRIBUTE_REMARKS,
				ATTRIBUTE_DATE,
				ATTRIBUTE_DET_METH
			;
			--dbms_output.put_line ('ATTRIBUTE: ' || ATTRIBUTE);
			--dbms_output.put_line ('ATTRIBUTE_VALUE: ' || ATTRIBUTE_VALUE);
			insert into attributes (
				ATTRIBUTE_ID,
				COLLECTION_OBJECT_ID,
				DETERMINED_BY_AGENT_ID,
				ATTRIBUTE_TYPE,
				ATTRIBUTE_VALUE,
				ATTRIBUTE_UNITS,
				ATTRIBUTE_REMARK,
				DETERMINED_DATE,
				DETERMINATION_METHOD 
			) values (
				ATTRIBUTE_ID,
				l_collection_object_id,
				ATTRIBUTE_DETERMINER_ID,
				ATTRIBUTE,
				ATTRIBUTE_VALUE,
				ATTRIBUTE_UNITS,
				ATTRIBUTE_REMARKS,
				ATTRIBUTE_DATE,
				ATTRIBUTE_DET_METH
			);
				 --dbms_output.put_line('inserted attribute');
		end if;
	end loop;
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_bulkload_attribute',collobjid);
END;       
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_bulkload_parts  (collobjid IN number) 
is
r_partname  specimen_part.PART_NAME%TYPE;
r_preservemethod  specimen_part.PRESERVE_METHOD%TYPE;
r_condn  coll_object.CONDITION%TYPE;
r_barcode  container.BARCODE%TYPE;
r_label  container.LABEL%TYPE;
r_lotcountmodifier  coll_object.LOT_COUNT_MODIFIER%TYPE;
r_lotcount  coll_object.LOT_COUNT%TYPE;
r_disposition  coll_object.COLL_OBJ_DISPOSITION%TYPE;
r_partremark  coll_object_remark.COLL_OBJECT_REMARKS%TYPE;
catitemcollid CATALOGED_ITEM.COLLECTION_OBJECT_ID%TYPE;
r_container_id container.container_id%TYPE;
part_id specimen_part.COLLECTION_OBJECT_ID%TYPE;
entered_person_id agent.agent_id%TYPE;
part_label varchar2(255);
institution_acronym container.institution_acronym%TYPE;
--error_msg varchar2(4000);
r_parent_container_id container.parent_container_id%TYPE;
DETERMINED_BY_AGENT_ID specimen_part_attribute.DETERMINED_BY_AGENT_ID%TYPE;
ATTRIBUTE specimen_part_attribute.attribute_type%TYPE;
ATTRIBUTE_VALUE specimen_part_attribute.ATTRIBUTE_VALUE%TYPE;
ATTRIBUTE_UNITS specimen_part_attribute.ATTRIBUTE_UNITS%TYPE;
ATTRIBUTE_REMARKS specimen_part_attribute.ATTRIBUTE_REMARK%TYPE;
ATTRIBUTE_DATE specimen_part_attribute.DETERMINED_DATE%TYPE;
ATTRIBUTE_DETERMINER_ID agent.agent_id%TYPE;
ATTRIBUTE_DETERMINER varchar2(255);
ATTRIBUTE_ID specimen_part_attribute.PART_ATTRIBUTE_ID%TYPE;
BEGIN
	--dbms_output.put_line ('parts...');
	--dbms_output.put_line ('got catcollid...');
	select institution_acronym into institution_acronym from bulkloader where collection_object_id = collobjid;
	--dbms_output.put_line ('got institution_acronym...');
	for i IN 1 .. 12 LOOP -- number of parts
	    --dbms_output.put_line('on part loop ' || i);
		execute immediate 'select count(*) from bulkloader where PART_NAME_' || i || ' is not null 
			and collection_object_id = ' || collobjid into num;
		if num = 1 then -- there's a part - insert it
				--dbms_output.put_line ('inserting a part...');
			execute immediate 'select 
				PART_NAME_' || i || ', 
                PRESERV_METHOD_' || i || ',
				PART_CONDITION_' || i || ', 
				PART_CONTAINER_UNIQUE_ID_' || i || ', 
				PART_CONTAINER_NAME_' || i || ',
                PART_LOT_CNT_MOD_' || i || ', 
				PART_LOT_COUNT_' || i || ', 
				PART_DISPOSITION_' || i || ', 
				PART_REMARK_' || i || ' 
			from bulkloader 
			where collection_object_id = ' || collobjid 
			into 
				r_partname,
                r_preservemethod,
				r_condn,
				r_barcode,
				r_label,
                r_lotcountmodifier,
				r_lotcount,
				r_disposition,
				r_partremark
			;
			select sq_collection_object_id.nextval into part_id from dual;
			--dbms_output.put_line ('got coll obj id');
			execute immediate 'select institution_acronym || '' '' || collection_cde || '' ' || l_cat_num || ' ''  || 
				part_name_' || i ||  ' from bulkloader where collection_object_id = ' || 
				collobjid into part_label;
			--dbms_output.put_line ('got label');
			INSERT INTO coll_object (
				COLLECTION_OBJECT_ID,
				COLL_OBJECT_TYPE,
				ENTERED_PERSON_ID,
				COLL_OBJECT_ENTERED_DATE,
				COLL_OBJ_DISPOSITION,
        LOT_COUNT_MODIFIER,
				LOT_COUNT,
				CONDITION 
			) VALUES (
				part_id,
				'SP',
				l_entered_person_id,
				sysdate,
				r_disposition,
        r_lotcountmodifier,
				r_lotcount,
				r_condn   
			);
			INSERT INTO specimen_part (	
				COLLECTION_OBJECT_ID,
				PART_NAME,
        PRESERVE_METHOD,
				DERIVED_FROM_CAT_ITEM
			) VALUES (
				part_id,
				r_partname,
        r_preservemethod,
				l_collection_object_id
			);
			if r_partremark is not null then
				INSERT INTO coll_object_remark (
						collection_object_id, 
						coll_object_remarks
				) VALUES (
					part_id, r_partremark);
			end if;
			--dbms_output.put_line ('made coll_obj_cont_hist');
			if r_barcode is not null then
			    -- find the container_id of the part we just made
			    SELECT container_id INTO r_container_id FROM coll_obj_cont_hist WHERE collection_object_id = part_id;
			    --dbms_output.put_line ('CURRENT part IS : ' || r_container_id);
				SELECT container_id into r_parent_container_id FROM container WHERE barcode = r_barcode;
				--dbms_output.put_line ('got parent contianer id: ' || r_parent_container_id);
				UPDATE container SET 
					parent_container_id = r_parent_container_id,
					parent_install_date = sysdate
				WHERE 
					container_id = r_container_id;
				/*if r_label is not null then
					UPDATE container SET label = r_label
						where container_id = r_container_id;
				end if;*/
			end if;			
		end if;
		--dbms_output.put_line ('parts loop de looooppppeeeee.....');
    --bulk part attributes
          for j IN 1 .. 8 LOOP -- number of attributes
          execute immediate 'select count(*) from bulkloader where part_' || i || '_att_name_' || j || ' is not null and 
            part_' || i || '_att_val_' || j || ' is not null and collection_object_id = ' || collobjid into num;
           --dbms_output.put_line ('num: ' || num);
          if num = 1 then -- there's an attribute - insert it
            select sq_attribute_id.nextval into ATTRIBUTE_ID from dual;
            --dbms_output.put_line ('ATTRIBUTE_ID: ' || ATTRIBUTE_ID);
            execute immediate 'select part_' || i || '_att_detby_' || j || ' from bulkloader where collection_object_id = ' || 
              collobjid into ATTRIBUTE_DETERMINER;
              --dbms_output.put_line ('ATTRIBUTE_DETERMINER: ' || ATTRIBUTE_DETERMINER);
            if ATTRIBUTE_DETERMINER is not null then
              select count(distinct(agent_id)) into num from agent_name where agent_name = ATTRIBUTE_DETERMINER;
              if num = 0 then
                error_msg := 'Bad part_'||i||'_att_detby_' || j;
                raise failed_validation;
              end if;
              select distinct(agent_id) into ATTRIBUTE_DETERMINER_ID from agent_name where agent_name = ATTRIBUTE_DETERMINER;
            else
              ATTRIBUTE_DETERMINER_ID := null;
            end if;
              execute immediate 'select part_' || i || '_att_name_' || j || 
                ',part_' || i || '_att_val_' || j ||
                ',part_' || i || '_att_units_' || j ||
                ',part_' || i || '_att_rem_' || j ||
                ',part_' || i || '_att_madedate_' || j ||
                ' from bulkloader where collection_object_id = ' || collobjid into
                ATTRIBUTE,
                ATTRIBUTE_VALUE,
                ATTRIBUTE_UNITS,
                ATTRIBUTE_REMARKS,
                ATTRIBUTE_DATE;
            --dbms_output.put_line ('ATTRIBUTE: ' || ATTRIBUTE);
            --dbms_output.put_line ('ATTRIBUTE_VALUE: ' || ATTRIBUTE_VALUE);
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
              part_id,
              ATTRIBUTE_DETERMINER_ID,
              ATTRIBUTE,
              ATTRIBUTE_VALUE,
              ATTRIBUTE_UNITS,
              ATTRIBUTE_REMARKS,
              ATTRIBUTE_DATE);
               --dbms_output.put_line('inserted attribute');
          end if;
        end loop;
	end loop;
--dbms_output.put_line ('made it thru parts');	
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_bulkload_parts',collobjid);
END;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_bulkload_otherid  (collobjid IN number) 
is
oidn  coll_obj_other_id_num.DISPLAY_VALUE%TYPE;
oidt  coll_obj_other_id_num.OTHER_ID_TYPE%TYPE;
catcollid cataloged_item.collection_object_id%TYPE;
BEGIN
	for i IN 1 .. 5 LOOP -- number of other IDs		
		execute immediate 'select count(*) from bulkloader where OTHER_ID_NUM_' || i || ' is not null 
			and collection_object_id = ' || collobjid into num;
		if num = 1 then -- there's an other ID number - insert it
			execute immediate 'select OTHER_ID_NUM_' || i || ', OTHER_ID_NUM_TYPE_' || i || ' from bulkloader where 
				collection_object_id = ' || collobjid
				into oidn,oidt;			
			/*
			insert into coll_obj_other_id_num (
				COLLECTION_OBJECT_ID,
				OTHER_ID_NUM,
				OTHER_ID_TYPE
			) values (
				l_collection_object_id,
				oidn,
				oidt
			);
			*/			
			-- call the function to attempt parsing other IDs out into components
			parse_other_id(l_collection_object_id, oidn, oidt);
		end if;
	end loop;		
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_bulkload_otherid',collobjid);
END;        
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_bulkload (collobjid IN NUMBER)
is
catcollid number;
someRandomString varchar2(4000);
someRandomStringTwo varchar2(4000);
someRandomNumber number;
someRandomNumberTwo number;
someRandomNumberThree number;
someRandomNumberFour number;
someRandomNumberFive number;
rec bulkloader%ROWTYPE;
gGeog_auth_rec_id geog_auth_rec.geog_auth_rec_id%TYPE;
newLocId  locality.locality_id%TYPE;
DETERMINED_BY_AGENT_ID  agent.agent_id%TYPE;
bulk_table_coll_obj_id number;
BEGIN
		SELECT * into rec FROM bulkloader where collection_object_id = collobjid;		
		--select catcollid into catcollid from bulkloader_keys where k_collection_object_id = collobjid;
		-- coll object and cataloged_item
		--dbms_output.put_line ('loadin a coll_object... ');
		--select entered_person_id into someRandomNumber from bulkloader_keys where k_collection_object_id = rec.collection_object_id;
		INSERT INTO coll_object (
			COLLECTION_OBJECT_ID,
			COLL_OBJECT_TYPE,
			ENTERED_PERSON_ID,
			COLL_OBJECT_ENTERED_DATE,
			COLL_OBJ_DISPOSITION,
			LOT_COUNT,
			CONDITION,
			FLAGS
		) VALUES (
			l_collection_object_id,
			'CI',
			l_entered_person_id,
			sysdate,
			'not applicable',
			1,
			'not applicable',
			rec.FLAGS
		)
		;
		--dbms_output.put_line ('loadied a coll_object... ');
		--select accn_id into someRandomNumber from bulkloader_keys where k_collection_object_id = rec.collection_object_id;
		--select K_CAT_NUM into someRandomNumberThree from bulkloader_keys where k_collection_object_id = rec.collection_object_id;
		--select collecting_event_id into someRandomNumberFour from bulkloader_keys where k_collection_object_id = rec.collection_object_id;
		--dbms_output.put_line ('keys colleventid: ' || someRandomNumberFour);
		--select collection_id into someRandomNumberFive from bulkloader_keys where k_collection_object_id = rec.collection_object_id;
		INSERT INTO cataloged_item (
			COLLECTION_OBJECT_ID,
			CAT_NUM,
			ACCN_ID,
			COLLECTING_EVENT_ID,
			COLLECTION_CDE,
			CATALOGED_ITEM_TYPE,
			COLLECTION_ID
			)
		VALUES (
			l_collection_object_id,
			l_cat_num,
			l_accn_id,
			l_collecting_event_id,
			rec.collection_cde,
			'BI',
			l_collection_id
		);
		commit; -- necessary so triggers work
		 -- relationship
		 IF (rec.relationship is not null) THEN
		 	IF (rec.RELATED_TO_NUMBER is null OR rec.RELATED_TO_NUM_TYPE is null) THEN
		 		error_msg := 'Incomplete relationship';
				raise failed_validation;
			END IF;
			insert into cf_temp_relations (
				collection_object_id,
				relationship,
				related_to_number,
				related_to_num_type,
                BIOL_INDIV_RELATION_REMARKS)
			VALUES (
				l_collection_object_id,
				rec.relationship,
				rec.RELATED_TO_NUMBER,
				rec.RELATED_TO_NUM_TYPE,
                rec.BIOL_INDIV_RELATION_REMARKS)
			;
		END IF;
		select sq_identification_id.nextval into someRandomNumber from dual;
	    IF (instr(rec.taxon_name,' {') > 1 AND instr(rec.taxon_name,'}') > 1) then
			someRandomString := regexp_replace(rec.taxon_name,'^.* {(.*)}$','\1');
	    ELSE
	        someRandomString:=rec.taxon_name;
	    END IF;
		insert into identification (
			IDENTIFICATION_ID,
			COLLECTION_OBJECT_ID,
			MADE_DATE,
			NATURE_OF_ID,
			ACCEPTED_ID_FG,
			IDENTIFICATION_REMARKS,
			TAXA_FORMULA,
			SCIENTIFIC_NAME
		) values (
			someRandomNumber,
			l_collection_object_id,
			rec.MADE_DATE,
			rec.NATURE_OF_ID,
			1,
			rec.IDENTIFICATION_REMARKS,
			l_taxa_formula,
			someRandomString
		);
		insert into identification_taxonomy (
			IDENTIFICATION_ID,
			TAXON_NAME_ID,
			VARIABLE
		) values (
			someRandomNumber,
			l_taxon_name_id_1,
			'A'
		);
		if l_taxon_name_id_2 is not null then
			insert into identification_taxonomy (
				IDENTIFICATION_ID,
				TAXON_NAME_ID,
				VARIABLE
			) values (
				someRandomNumber,
				l_taxon_name_id_2,
				'B'
			);
		end if;
		insert into identification_agent (
			IDENTIFICATION_ID,
			AGENT_ID,
			IDENTIFIER_ORDER
		) values (
			someRandomNumber,
			l_id_made_by_agent_id,
			1
		);
			if rec.COLL_OBJECT_HABITAT is not null OR
			rec.ASSOCIATED_SPECIES is not null OR 
			rec.COLL_OBJECT_REMARKS is not null then
			insert into coll_object_remark (
				COLLECTION_OBJECT_ID,
				COLL_OBJECT_REMARKS,
				HABITAT,
				ASSOCIATED_SPECIES
			) values (
				l_collection_object_id,
				rec.COLL_OBJECT_REMARKS,
				rec.COLL_OBJECT_HABITAT,
				rec.ASSOCIATED_SPECIES
			);
		end if;
		-- collectors
		for i IN 1 .. 8 LOOP -- number of collectors
			execute immediate 'select count(*)
				FROM bulkloader
				where 
				COLLECTOR_AGENT_' || i || ' is not null and 
				collection_object_id = ' || rec.collection_object_id 
				INTO num;
			if num > 0 then
				execute immediate 'select 
					COLLECTOR_AGENT_' || i || ', 
					trim(COLLECTOR_ROLE_' || i || ')
					FROM bulkloader
					where collection_object_id = ' || rec.collection_object_id  
					INTO someRandomString,
					someRandomStringTwo;
        someRandomStringTwo := trim(someRandomStringTwo);
				select count(distinct(agent_id))  into num from agent_name where agent_name = someRandomString;
				if num != 1 then
					error_msg := 'Bad COLLECTOR_AGENT_' || i || '(' || someRandomString || ')';
					raise failed_validation;
				else
					select distinct(agent_id) into someRandomNumber from agent_name where agent_name = someRandomString;
					insert into collector (
						COLLECTION_OBJECT_ID,
						AGENT_ID,
						COLLECTOR_ROLE,
						COLL_ORDER
					) values (
						l_collection_object_id,
						someRandomNumber,
						someRandomStringTwo,
						i
					);
				end if;
			end if;
		END LOOP;
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_bulkload',collobjid);
END;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_bulkload_coll_event  (collobjid IN number) 
is
rec bulkloader%ROWTYPE;
gGeog_auth_rec_id geog_auth_rec.geog_auth_rec_id%TYPE;
gcollecting_event_id collecting_event.collecting_event_id%TYPE;
--error_msg varchar2(4000);  
k_locality_id locality.locality_id%TYPE;
BEGIN
	select * into rec from bulkloader where collection_object_id=collobjid;
	IF rec.collecting_event_id IS NULL THEN
    	select count(*) into num from
    	collecting_event where
    	locality_id = l_locality_id and
    	verbatim_date = rec.verbatim_date and
    	began_date = rec.began_date and
    	ended_date = rec.ended_date and
    	collecting_source = rec.collecting_source AND
      nvl(collecting_time,1)=nvl(rec.collecting_time,1) AND
      nvl(fish_field_number,1)= nvl(rec.fish_field_number,1) AND
      nvl(verbatimCoordinates,1)= nvl(rec.verbatimCoordinates,1) AND
      nvl(verbatimLatitude,1)= nvl(rec.verbatimLatitude,1) AND
      nvl(verbatimLongitude,1)= nvl(rec.verbatimLongitude,1) AND
      nvl(verbatimCoordinateSystem,1)= nvl(rec.verbatimCoordinateSystem,1) AND
      nvl(verbatimSRS,1)= nvl(rec.verbatimSRS,1) AND
      nvl(startDayOfYear,1)= nvl(rec.startDayOfYear,1) AND
      nvl(endDayOfYear,1)= nvl(rec.endDayOfYear,1) AND
    	VERBATIM_LOCALITY || ':' ||
    	coll_event_remarks || ':' ||
    	collecting_method || ':' ||
    	habitat_desc|| ':' ||
        verbatimdepth || ':' ||
        verbatimelevation
    	= 
    	rec.VERBATIM_LOCALITY || ':' ||
    	rec.coll_event_remarks || ':' ||
    	rec.collecting_method || ':' ||
    	rec.habitat_desc || ':' ||
        rec.verbatimdepth || ':' ||
        rec.verbatimelevation;
    	--dbms_output.put_line('fund events: ' || num);
    	if (num = 1) then
    		--dbms_output.put_line ('there is an existing coll event');
    		select collecting_event.collecting_event_id into gcollecting_event_id from
    		collecting_event where
    		locality_id = l_locality_id and
    	    verbatim_date = rec.verbatim_date and
    	    began_date = rec.began_date and
    	    ended_date = rec.ended_date and
    	    collecting_source = rec.collecting_source AND
          nvl(collecting_time,1)=nvl(rec.collecting_time,1) AND
          nvl(fish_field_number,1)= nvl(rec.fish_field_number,1) AND
          nvl(verbatimCoordinates,1)= nvl(rec.verbatimCoordinates,1) AND
          nvl(verbatimLatitude,1)= nvl(rec.verbatimLatitude,1) AND
          nvl(verbatimLongitude,1)= nvl(rec.verbatimLongitude,1) AND
          nvl(verbatimCoordinateSystem,1)= nvl(rec.verbatimCoordinateSystem,1) AND
          nvl(verbatimSRS,1)= nvl(rec.verbatimSRS,1) AND
          nvl(startDayOfYear,1)= nvl(rec.startDayOfYear,1) AND
          nvl(endDayOfYear,1)= nvl(rec.endDayOfYear,1) AND
    	    VERBATIM_LOCALITY || ':' ||
    	    coll_event_remarks || ':' ||
    	    collecting_method || ':' ||
    	    habitat_desc || ':' ||
            verbatimdepth || ':' ||
            verbatimelevation
        	= 
        	rec.VERBATIM_LOCALITY || ':' ||
        	rec.coll_event_remarks || ':' ||
        	rec.collecting_method || ':' ||
        	rec.habitat_desc || ':' ||
            rec.verbatimdepth || ':' ||
            rec.verbatimelevation;
    		l_collecting_event_id := gcollecting_event_id;
    		--dbms_output.put_line('there is an existing coll event');
    	else
    		--dbms_output.put_line ('there is NOT an existing coll event');
    		select sq_collecting_event_id.nextval into gcollecting_event_id from dual;
    		--dbms_output.put_line ('gcollecting_event_id: ' || gcollecting_event_id);
    		insert into collecting_event (
    			collecting_event_id,
    			locality_id,
    			verbatim_date,
    			VERBATIM_LOCALITY,
                verbatimdepth,
                verbatimelevation,
    			began_date,
    			ended_date,
    			coll_event_remarks,
    			collecting_method,
    			collecting_source,
    			habitat_desc,
          fish_field_number,
          collecting_time,
          verbatimCoordinates,
          verbatimLatitude,
          verbatimLongitude,
          verbatimCoordinateSystem,
          verbatimSRS,
          startDayOfYear,
          endDayOfYear)
    		values (
    			gcollecting_event_id,
    			l_locality_id,
    			rec.verbatim_date,
    			rec.VERBATIM_LOCALITY,
                rec.verbatimdepth,
                rec.verbatimelevation,
    			rec.began_date,			
    			rec.ended_date,
    			rec.coll_event_remarks,
    			rec.collecting_method,
    			rec.collecting_source,
    			rec.habitat_desc,
          rec.fish_field_number,
          rec.collecting_time,
          rec.verbatimCoordinates,
          rec.verbatimLatitude,
          rec.verbatimLongitude,
          rec.verbatimCoordinateSystem,
          rec.verbatimSRS,
          rec.startDayOfYear,
          rec.endDayOfYear
    			);
    		--dbms_output.put_line ('made new coll event');
    		l_collecting_event_id := gcollecting_event_id;
    		commit;
    	end if;
    ELSE -- use picked collecting_event_id
        l_collecting_event_id := rec.collecting_event_id;
	END IF; -- end picked collecting_event_id check
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_bulkload_coll_event',collobjid);
END;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_make_bulkloader_locality  (collobjid IN number) 
is
aRec bulkloader%ROWTYPE;
determiner_id number;
gGeog_auth_rec_id geog_auth_rec.geog_auth_rec_id%TYPE;
lookup_sovereign_nation locality.sovereign_nation%TYPE;
gLocalityId locality.locality_id%TYPE;
gLatLongId lat_long.lat_long_id%TYPE;
verifiedbyid lat_long.VERIFIED_BY_AGENT_ID%TYPE;
ATTRIBUTE attributes.attribute_type%TYPE;
ATTRIBUTE_VALUE attributes.ATTRIBUTE_VALUE%TYPE;
ATTRIBUTE_UNITS attributes.ATTRIBUTE_UNITS%TYPE;
ATTRIBUTE_REMARKS attributes.ATTRIBUTE_REMARK%TYPE;
ATTRIBUTE_DATE attributes.DETERMINED_DATE%TYPE;
ATTRIBUTE_DET_METH attributes.DETERMINATION_METHOD%TYPE;
ATTRIBUTE_DETERMINER_ID agent.agent_id%TYPE;
ATTRIBUTE_DETERMINER varchar2(255);
ATTRIBUTE_ID attributes.ATTRIBUTE_ID%TYPE;
BEGIN
	select * into aRec from bulkloader where collection_object_id=collobjid;
	IF aRec.locality_id is null AND aRec.collecting_event_id IS NULL then -- it should always be
	--dbms_output.put_line('aRec.locality_id is null AND aRec.collecting_event_id IS NULL');
		select geog_auth_rec_id into gGeog_auth_rec_id from geog_auth_rec where higher_geog = aRec.higher_geog;
		select sq_locality_id.nextval into gLocalityId from dual;
		select sq_lat_long_id.nextval into gLatLongId from dual;
        -- lookup sovereign_nation from country, populating with high seas if no country and from
        -- an ocean, otherwise fill with unknown.
        select 
            case when country is not null and sovereign_nation is not null then country 
                 when continent_ocean like '%Ocean%' and country is null then 'High Seas'
                 when country = 'United States' then 'United States of America'
                 when country = 'United Kingdom' then 'United Kingdom of Great Britain and Northern Ireland'
                 when country = 'Venezuela' then 'Venezuela, Bolivarian Republic of'
                 when country = 'Tanzania' then 'Tanzania, United Republic of'
                 when country = 'Comonwealth of the Bahamas' then 'Bahamas'
            else '[unknown]'
            end
            as sovereign_nation into lookup_sovereign_nation
        from geog_auth_rec left join ctsovereign_nation on geog_auth_rec.country = ctsovereign_nation.sovereign_nation
        where higher_geog = aRec.higher_geog;     
    
		INSERT INTO locality (
			 LOCALITY_ID,
			 GEOG_AUTH_REC_ID,
			 MAXIMUM_ELEVATION,
			 MINIMUM_ELEVATION,
			 ORIG_ELEV_UNITS,
			 SPEC_LOCALITY,
			 LOCALITY_REMARKS,
			 DEPTH_UNITS,
			 MIN_DEPTH,
			 MAX_DEPTH,
             SOVEREIGN_NATION
		) values (
			gLocalityId,
			gGeog_auth_rec_id,
			aRec.MAXIMUM_ELEVATION,
			aRec.MINIMUM_ELEVATION,
			 aRec.ORIG_ELEV_UNITS,
			 aRec.SPEC_LOCALITY,
			 aRec.LOCALITY_REMARKS,
			 aRec.DEPTH_UNITS,
			 aRec.MIN_DEPTH,
			 aRec.MAX_DEPTH,
             lookup_sovereign_nation);
			--dbms_output.put_line('made a locality');
		for i IN 1 .. 6 LOOP -- number of geology attributes
		execute immediate 'select count(*) from bulkloader where geology_attribute_' || i || ' is not null and 
			geo_att_value_' || i || ' is not null and collection_object_id = ' || collobjid into num;
		--dbms_output.put_line ('num: ' || num);
		if num = 1 then -- there's an attribute - insert it
			ATTRIBUTE := NULL;
			ATTRIBUTE_VALUE := NULL;
			ATTRIBUTE_DATE := NULL;
			ATTRIBUTE_DETERMINER := NULL;
			ATTRIBUTE_DET_METH := NULL;
			ATTRIBUTE_REMARKS := NULL;
			ATTRIBUTE_DETERMINER_ID := NULL;
			execute immediate 'select geology_attribute_' || i || 
				',geo_att_value_' || i || 
				',geo_att_determined_date_' || i || 
				',geo_att_determiner_' || i ||
				',geo_att_determined_method_' || i ||
				',geo_att_remark_' || i || 
				' from bulkloader where collection_object_id = ' || collobjid into
				ATTRIBUTE,
				ATTRIBUTE_VALUE,
				ATTRIBUTE_DATE,
				ATTRIBUTE_DETERMINER,
				ATTRIBUTE_DET_METH,
				ATTRIBUTE_REMARKS
			;
			if ATTRIBUTE_DETERMINER is NOT null then
			    select count(distinct(agent_id)) into num from agent_name where agent_name = ATTRIBUTE_DETERMINER;
			    if num = 0 then
    				error_msg := 'Bad ATTRIBUTE_DETERMINER_' || i;
    				raise failed_validation;
    			end if;
    			select distinct(agent_id) into ATTRIBUTE_DETERMINER_ID from agent_name where agent_name = ATTRIBUTE_DETERMINER;
    	    ELSE
    			ATTRIBUTE_DETERMINER_ID:=NULL;
			end if;
		--dbms_output.put_line ('num: ' || num);
		--dbms_output.put_line ('ATTRIBUTE: ' || ATTRIBUTE);
		--dbms_output.put_line ('ATTRIBUTE_VALUE: ' || ATTRIBUTE_VALUE);
             insert into geology_attributes (
				locality_id,
				geology_attribute,
				geo_att_value,
				geo_att_determiner_id,
				geo_att_determined_date,
				geo_att_determined_method,
				geo_att_remark
			) values (
				gLocalityId,
				ATTRIBUTE,
				ATTRIBUTE_VALUE,
				ATTRIBUTE_DETERMINER_ID,
				ATTRIBUTE_DATE,
				ATTRIBUTE_DET_METH,
				ATTRIBUTE_REMARKS
			);
				--dbms_output.put_line ('inserted attribute');
		end if;
	end loop;

		IF aRec.ORIG_LAT_LONG_UNITS is not null THEN
				--dbms_output.put_line('making a lat/long');
				select distinct(agent_id) into determiner_id from agent_name where agent_name = aRec.DETERMINED_BY_AGENT;
                   --dbms_output.put_line('got determiner');
                   --dbms_output.put_line(' aRec.ORIG_LAT_LONG_UNITS: ' ||  aRec.ORIG_LAT_LONG_UNITS);
                if aRec.VERIFICATIONSTATUS = 'verified by MCZ collection' then 
                    verifiedbyid := l_entered_person_id;
                else 
                    verifiedbyid := null;
                END IF;    
			IF aRec.ORIG_LAT_LONG_UNITS = 'deg. min. sec.' THEN
					INSERT INTO lat_long (
						 LAT_LONG_ID,
						 LOCALITY_ID,
						 ORIG_LAT_LONG_UNITS,
						 DETERMINED_BY_AGENT_ID,
						 DETERMINED_DATE,
						 LAT_LONG_REF_SOURCE,
						 LAT_LONG_REMARKS,
						 MAX_ERROR_DISTANCE,
						 MAX_ERROR_UNITS,
						 ACCEPTED_LAT_LONG_FG,
						 GEOREFMETHOD,
						 VERIFICATIONSTATUS,
						 datum,
						 lat_deg,
						 long_deg,
						 lat_min,
						 lat_sec,
						 long_min,
						 long_sec,
						 lat_dir,
						 long_dir,
						 extent,
						 gpsaccuracy,
                         VERIFIED_BY_AGENT_ID)
					values (
						gLatLongId,
						gLocalityId,
						aRec.ORIG_LAT_LONG_UNITS,
						determiner_id,
						 aRec.DETERMINED_DATE,
						 aRec.LAT_LONG_REF_SOURCE,
						 aRec.LAT_LONG_REMARKS,
						 aRec.MAX_ERROR_DISTANCE,
						 aRec.MAX_ERROR_UNITS,
						 1,
						 aRec.GEOREFMETHOD,
						 aRec.VERIFICATIONSTATUS,
						 aRec.datum,
						 aRec.latdeg,
						 aRec.longdeg,
						 aRec.latmin,
						 aRec.latsec,
						 aRec.longmin,
						 aRec.longsec,
						 aRec.latdir,
						 aRec.longdir,
						 aRec.extent,
						 aRec.gpsaccuracy,
                         verifiedbyid);
				ELSIF aRec.ORIG_LAT_LONG_UNITS = 'decimal degrees' THEN
				    --dbms_output.put_line('inserting decimal degrees....');
				    --dbms_output.put_line('gLatLongId: ' || gLatLongId);
				    --dbms_output.put_line('gLocalityId: ' || gLocalityId);
				    --dbms_output.put_line('aRec.ORIG_LAT_LONG_UNITS: ' || aRec.ORIG_LAT_LONG_UNITS);
				    --dbms_output.put_line('determiner_id: ' || determiner_id);
				    --dbms_output.put_line('aRec.DETERMINED_DATE,: ' || aRec.DETERMINED_DATE);
				    --dbms_output.put_line('aRec.LAT_LONG_REF_SOURCE: ' || aRec.LAT_LONG_REF_SOURCE);
				    --dbms_output.put_line('aRec.LAT_LONG_REMARKS: ' || aRec.LAT_LONG_REMARKS);
				    --dbms_output.put_line('aRec.MAX_ERROR_DISTANCE: ' || aRec.MAX_ERROR_DISTANCE);
				    --dbms_output.put_line('aRec.MAX_ERROR_UNITS: ' || aRec.MAX_ERROR_UNITS);
				    --dbms_output.put_line('aRec.GEOREFMETHOD: ' || aRec.GEOREFMETHOD);
				    --dbms_output.put_line('aRec.VERIFICATIONSTATUS: ' || aRec.VERIFICATIONSTATUS);
				    --dbms_output.put_line('aRec.datum: ' || aRec.datum);
				    --dbms_output.put_line('aRec.dec_lat: ' || aRec.dec_lat);
				    --dbms_output.put_line('aRec.dec_long: ' || aRec.dec_long);
				    --dbms_output.put_line('aRec.extent: ' || aRec.EXTENT);
				    --dbms_output.put_line('aRec.gpsaccuracy: ' || aRec.gpsaccuracy);
				     --dbms_output.put_line('thats all folks ');
					INSERT INTO lat_long (
						 LAT_LONG_ID,
						 LOCALITY_ID,
						 ORIG_LAT_LONG_UNITS,
						 DETERMINED_BY_AGENT_ID,
						 DETERMINED_DATE,
						 LAT_LONG_REF_SOURCE,
						 LAT_LONG_REMARKS,
						 MAX_ERROR_DISTANCE,
						 MAX_ERROR_UNITS,
						 ACCEPTED_LAT_LONG_FG,
						 GEOREFMETHOD,
						 VERIFICATIONSTATUS,
						 datum,
						 dec_lat,
						 dec_long,
						 extent,
						 gpsaccuracy,
                         VERIFIED_BY_AGENT_ID)
					values (
						gLatLongId,
						gLocalityId,
						aRec.ORIG_LAT_LONG_UNITS,
						determiner_id,
						 aRec.DETERMINED_DATE,
						 aRec.LAT_LONG_REF_SOURCE,
						 aRec.LAT_LONG_REMARKS,
						 aRec.MAX_ERROR_DISTANCE,
						 aRec.MAX_ERROR_UNITS,
						 1,
						 aRec.GEOREFMETHOD,
						 aRec.VERIFICATIONSTATUS,
						  aRec.datum,
						 aRec.dec_lat,
						 aRec.dec_long,
						 aRec.extent,
						 aRec.gpsaccuracy,
                         verifiedbyid);
						--dbms_output.put_line('inserted DD');
				ELSIF aRec.ORIG_LAT_LONG_UNITS = 'UTM' THEN
					INSERT INTO lat_long (
						 LAT_LONG_ID,
						 LOCALITY_ID,
						 ORIG_LAT_LONG_UNITS,
						 DETERMINED_BY_AGENT_ID,
						 DETERMINED_DATE,
						 LAT_LONG_REF_SOURCE,
						 LAT_LONG_REMARKS,
						 MAX_ERROR_DISTANCE,
						 MAX_ERROR_UNITS,
						 ACCEPTED_LAT_LONG_FG,
						 GEOREFMETHOD,
						 VERIFICATIONSTATUS,
						 datum,
						 utm_ew,
						 utm_ns,
						 utm_zone,
						 extent,
						 gpsaccuracy,
                         VERIFIED_BY_AGENT_ID)
					values (
						gLatLongId,
						gLocalityId,
						aRec.ORIG_LAT_LONG_UNITS,
						determiner_id,
						 aRec.DETERMINED_DATE,
						 aRec.LAT_LONG_REF_SOURCE,
						 aRec.LAT_LONG_REMARKS,
						 aRec.MAX_ERROR_DISTANCE,
						 aRec.MAX_ERROR_UNITS,
						 1,
						 aRec.GEOREFMETHOD,
						 aRec.VERIFICATIONSTATUS,
						  aRec.datum,						 
						 aRec.utm_ew,
						 aRec.utm_ns,
						 aRec.utm_zone,
						 aRec.extent,
						 aRec.gpsaccuracy,
                         verifiedbyid);
				ELSIF aRec.ORIG_LAT_LONG_UNITS = 'degrees dec. minutes' THEN
                   --dbms_output.put_line('inserting degrees dec. minutes....');
				   --dbms_output.put_line('gLatLongId: ' || gLatLongId);
				   --dbms_output.put_line('gLocalityId: ' || gLocalityId);
				   --dbms_output.put_line('aRec.ORIG_LAT_LONG_UNITS: ' || aRec.ORIG_LAT_LONG_UNITS);
				   --dbms_output.put_line('determiner_id: ' || determiner_id);
				   --dbms_output.put_line('aRec.DETERMINED_DATE,: ' || aRec.DETERMINED_DATE);
				   --dbms_output.put_line('aRec.LAT_LONG_REF_SOURCE: ' || aRec.LAT_LONG_REF_SOURCE);
				   --dbms_output.put_line('aRec.LAT_LONG_REMARKS: ' || aRec.LAT_LONG_REMARKS);
				   --dbms_output.put_line('aRec.MAX_ERROR_DISTANCE: ' || aRec.MAX_ERROR_DISTANCE);
				   --dbms_output.put_line('aRec.MAX_ERROR_UNITS: ' || aRec.MAX_ERROR_UNITS);
				   --dbms_output.put_line('aRec.GEOREFMETHOD: ' || aRec.GEOREFMETHOD);
				   --dbms_output.put_line('aRec.VERIFICATIONSTATUS: ' || aRec.VERIFICATIONSTATUS);
				   --dbms_output.put_line('aRec.datum: ' || aRec.datum);
				   --dbms_output.put_line('aRec.LAT_DEG: ' || aRec.LATDEG);
                   --dbms_output.put_line('aRec.DEC_LAT_MIN: ' || aRec.DEC_LAT_MIN);
                   --dbms_output.put_line('aRec.LAT_dir: ' || aRec.LATdir);
				   --dbms_output.put_line('aRec.dec_long: ' || aRec.LONGDEG);
                   --dbms_output.put_line('aRec.DEC_long_MIN: ' || aRec.DEC_long_MIN);
                   --dbms_output.put_line('aRec.Long_dir: ' || aRec.Longdir);
				   --dbms_output.put_line('aRec.extent: ' || aRec.EXTENT);
				   --dbms_output.put_line('aRec.gpsaccuracy: ' || aRec.gpsaccuracy);
				    --dbms_output.put_line('thats all folks ');
					INSERT INTO lat_long (
						 LAT_LONG_ID,
						 LOCALITY_ID,
						 ORIG_LAT_LONG_UNITS,
						 DETERMINED_BY_AGENT_ID,
						 DETERMINED_DATE,
						 LAT_LONG_REF_SOURCE,
						 LAT_LONG_REMARKS,
						 MAX_ERROR_DISTANCE,
						 MAX_ERROR_UNITS,
						 ACCEPTED_LAT_LONG_FG,
						 GEOREFMETHOD,
						 VERIFICATIONSTATUS,
						 datum,
						 lat_deg,
						 DEC_LAT_MIN,
						 long_deg,
						 DEC_LONG_MIN,
						 lat_dir,
						 LONG_DIR,
						 extent,
						 gpsaccuracy,
                         VERIFIED_BY_AGENT_ID)
					values (
						gLatLongId,
						gLocalityId,
						aRec.ORIG_LAT_LONG_UNITS,
						determiner_id,
						 aRec.DETERMINED_DATE,
						 aRec.LAT_LONG_REF_SOURCE,
						 aRec.LAT_LONG_REMARKS,
						 aRec.MAX_ERROR_DISTANCE,
						 aRec.MAX_ERROR_UNITS,
						 1,
						 aRec.GEOREFMETHOD,
						 aRec.VERIFICATIONSTATUS,
						 arec.datum,
						aRec.latdeg,
						 aRec.DEC_LAT_MIN,
						 aRec.longdeg,
						 aRec.DEC_LONG_MIN,
						 aRec.latdir,
						 aRec.longdir,
						 aRec.extent,
						 aRec.gpsaccuracy,
                         VERIFIEDBYID);
				ELSE
					error_msg := 'bad unit values';
					raise failed_validation;
				END IF;
       --dbms_output.put_line('inserted lat/long');
      ELSE
        If (aRec.latdeg is not null or aRec.longdeg is not null or aRec.latmin is not null or aRec.latsec is not null 
          or aRec.longmin is not null or aRec.longsec is not null or aRec.latdir is not null or aRec.longdir is not null
          or aRec.dec_lat is not null or aRec.dec_long is not null or aRec.utm_ew is not null or aRec.utm_ns is not null or aRec.utm_zone is not null
          or aRec.DEC_LAT_MIN is not null or aRec.DEC_LONG_MIN is not null) then 
            error_msg := 'ORIG_LAT_LONG_UNITS cannot be null if Georef data is present';
            raise failed_validation;
        End if;
			END IF;
			l_locality_id := gLocalityId;
	ELSE
		error_msg := 'Bad record passed to make_bulkload_locality';
		raise failed_validation;
	END IF; -- locid is null check
	commit;
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_make_bulkloader_locality',collobjid);
END;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_bulkload_locality  (collobjid IN number) 
is
aRec bulkloader%ROWTYPE;
determiner_id number;
gGeog_auth_rec_id geog_auth_rec.geog_auth_rec_id%TYPE;
gLocalityId locality.locality_id%TYPE;
gCollEvntId collecting_event.collecting_event_id%TYPE;
BEGIN
	--dbms_output.put_line ('locality thingy running...');
	select * into aRec from bulkloader where collection_object_id=collobjid;
	--dbms_output.put_line ('Good higher_geog');
	if aRec.locality_id is null AND aRec.collecting_event_id IS NULL then -- otherwise, we already have what we need
	    select count(geog_auth_rec_id) into num from geog_auth_rec where higher_geog = aRec.higher_geog;
	    if num != 1 then
        	error_msg := 'Bad higher_geog';
        	raise failed_validation;
        END IF;
        IF aRec.DETERMINED_BY_AGENT IS NOT NULL and aRec.ORIG_LAT_LONG_UNITS is not null THEN
            select count(distinct(agent_id)) into num from agent_name where agent_name = aRec.DETERMINED_BY_AGENT;
			if num != 1 then
				error_msg := 'Bad lat/long determined_by_agent';
				raise failed_validation;
				--dbms_output.put_line ('Bad DETERMINED_BY_AGENT');
			end if;
			select distinct(agent_id) into determiner_id from agent_name where agent_name = aRec.DETERMINED_BY_AGENT;
		ELSE
		    determiner_id := NULL;
        END IF;	
		--dbms_output.put_line ('need to find or make a locality');
		select geog_auth_rec_id into gGeog_auth_rec_id from geog_auth_rec where higher_geog = aRec.higher_geog;
		IF aRec.orig_lat_long_units IS NULL THEN
    		select 
    	        nvl(min(locality.locality_id),-1)
            INTO
    	        gLocalityId
            FROM 
            	locality,
            	lat_long
            WHERE
                geog_auth_rec_id = gGeog_auth_rec_id AND
                locality.locality_id = lat_long.locality_id (+) AND
                lat_long.locality_id IS NULL AND
                NVL(MAXIMUM_ELEVATION,-1) = NVL(aRec.maximum_elevation,-1) AND
            	NVL(MINIMUM_ELEVATION,-1) = NVL(aRec.minimum_elevation,-1) AND
            	NVL(ORIG_ELEV_UNITS,'NULL') = NVL(aRec.orig_elev_units,'NULL') AND
            	NVL(MIN_DEPTH,-1) = nvl(aRec.min_depth,-1) AND
            	NVL(MAX_DEPTH,-1) = nvl(aRec.max_depth,-1) AND
            	NVL(SPEC_LOCALITY,'NULL') = NVL(aRec.spec_locality,'NULL') AND
            	NVL(LOCALITY_REMARKS,'NULL') = NVL(aRec.locality_remarks,'NULL') AND
            	NVL(DEPTH_UNITS,'NULL') = NVL(aRec.depth_units,'NULL') AND
                nvl(concatGeologyAttributeDetail(locality.locality_id),'NULL') = nvl(b_concatGeologyAttributeDetail(aRec.collection_object_id),'NULL')
            	-- needs added
            	--NVL(NOGEOREFBECAUSE,'NULL') = NVL(aRec.nogeorefbecause,'NULL');
            ;
		ELSIF aRec.orig_lat_long_units = 'decimal degrees' THEN
            select 
    	        nvl(min(locality.locality_id),-1)			 
            INTO
    	        gLocalityId
            FROM 
            	locality,
            	accepted_lat_long
            WHERE
                geog_auth_rec_id = gGeog_auth_rec_id AND
                locality.locality_id = accepted_lat_long.locality_id AND
                accepted_lat_long.orig_lat_long_units = 'decimal degrees' AND
                NVL(MAXIMUM_ELEVATION,-1) = NVL(aRec.maximum_elevation,-1) AND
            	NVL(MINIMUM_ELEVATION,-1) = NVL(aRec.minimum_elevation,-1) AND
            	NVL(ORIG_ELEV_UNITS,'NULL') = NVL(aRec.orig_elev_units,'NULL') AND
            	NVL(MIN_DEPTH,-1) = nvl(aRec.min_depth,-1) AND
            	NVL(MAX_DEPTH,-1) = nvl(aRec.max_depth,-1) AND
            	NVL(SPEC_LOCALITY,'NULL') = NVL(aRec.spec_locality,'NULL') AND
            	NVL(LOCALITY_REMARKS,'NULL') = NVL(aRec.locality_remarks,'NULL') AND
            	NVL(DEPTH_UNITS,'NULL') = NVL(aRec.depth_units,'NULL') AND
                nvl(concatGeologyAttributeDetail(locality.locality_id),'NULL') = nvl(b_concatGeologyAttributeDetail(aRec.collection_object_id),'NULL') AND
            	--NVL(NOGEOREFBECAUSE,'NULL') = NVL(aRec.nogeorefbecause,'NULL');
            	-- generic latlong stuff
                NVL(datum,'NULL') = NVL(aRec.datum,'NULL') AND
            	NVL(determined_by_agent_id,-1) = nvl(determiner_id,-1) AND
            	NVL(determined_date,'1600-01-01') = NVL(to_date(aRec.determined_date),'1600-01-01') AND 
            	NVL(lat_long_ref_source,'NULL') = NVL(aRec.lat_long_ref_source,'NULL') AND 
            	NVL(lat_long_remarks,'NULL') = NVL(aRec.lat_long_remarks,'NULL')  AND 
            	NVL(max_error_distance,-1) = nvl(aRec.max_error_distance,-1) AND
            	NVL(max_error_units,'NULL') = NVL(aRec.max_error_units,'NULL') AND 
            	NVL(extent,-1) = nvl(aRec.extent,-1) AND
            	NVL(gpsaccuracy,-1) = nvl(aRec.gpsaccuracy,-1) AND
            	NVL(georefmethod,'NULL') = NVL(aRec.georefmethod,'NULL')  AND 
            	NVL(verificationstatus,'NULL') = NVL(aRec.verificationstatus,'NULL') AND 
            	-- dec_lat stuff
            	NVL(DEC_LAT,-1) = nvl(aRec.DEC_LAT,-1) AND
            	NVL(DEC_LONG,-1) = nvl(aRec.DEC_LONG,-1)
            ;	
        ELSIF aRec.orig_lat_long_units = 'UTM' THEN
            select 
    	        nvl(min(locality.locality_id),-1)			 
            INTO
    	        gLocalityId
            FROM 
            	locality,
            	accepted_lat_long
            WHERE
                geog_auth_rec_id = gGeog_auth_rec_id AND
                locality.locality_id = accepted_lat_long.locality_id AND
                accepted_lat_long.orig_lat_long_units = 'UTM' AND
                NVL(MAXIMUM_ELEVATION,-1) = NVL(aRec.maximum_elevation,-1) AND
            	NVL(MINIMUM_ELEVATION,-1) = NVL(aRec.minimum_elevation,-1) AND
            	NVL(ORIG_ELEV_UNITS,'NULL') = NVL(aRec.orig_elev_units,'NULL') AND
            	NVL(MIN_DEPTH,-1) = nvl(aRec.min_depth,-1) AND
            	NVL(MAX_DEPTH,-1) = nvl(aRec.max_depth,-1) AND
            	NVL(SPEC_LOCALITY,'NULL') = NVL(aRec.spec_locality,'NULL') AND
            	NVL(LOCALITY_REMARKS,'NULL') = NVL(aRec.locality_remarks,'NULL') AND
            	NVL(DEPTH_UNITS,'NULL') = NVL(aRec.depth_units,'NULL') AND
                nvl(concatGeologyAttributeDetail(locality.locality_id),'NULL') = nvl(b_concatGeologyAttributeDetail(aRec.collection_object_id),'NULL') AND
            	--NVL(NOGEOREFBECAUSE,'NULL') = NVL(aRec.nogeorefbecause,'NULL');
            	-- generic latlong stuff
                NVL(datum,'NULL') = NVL(aRec.datum,'NULL') AND
            	NVL(determined_by_agent_id,-1) = nvl(determiner_id,-1) AND
            	NVL(determined_date,'1600-01-01') = NVL(to_date(aRec.determined_date),'1600-01-01') AND 
            	NVL(lat_long_ref_source,'NULL') = NVL(aRec.lat_long_ref_source,'NULL') AND 
            	NVL(lat_long_remarks,'NULL') = NVL(aRec.lat_long_remarks,'NULL')  AND 
            	NVL(max_error_distance,-1) = nvl(aRec.max_error_distance,-1) AND
            	NVL(max_error_units,'NULL') = NVL(aRec.max_error_units,'NULL') AND 
            	NVL(extent,-1) = nvl(aRec.extent,-1) AND
            	NVL(gpsaccuracy,-1) = nvl(aRec.gpsaccuracy,-1) AND
            	NVL(georefmethod,'NULL') = NVL(aRec.georefmethod,'NULL')  AND 
            	NVL(verificationstatus,'NULL') = NVL(aRec.verificationstatus,'NULL') AND 
            	-- UTM stuff
            	NVL(UTM_EW,-1) = nvl(aRec.UTM_EW,-1) AND
            	NVL(UTM_NS,-1) = nvl(aRec.UTM_NS,-1) AND
            	NVL(UTM_ZONE,'NULL') = NVL(aRec.UTM_ZONE,'NULL')
            ;
        ELSIF aRec.orig_lat_long_units = 'degrees dec. minutes' THEN
            select 
    	        nvl(min(locality.locality_id),-1)			 
            INTO
    	        gLocalityId
            FROM 
            	locality,
            	accepted_lat_long
            WHERE
                geog_auth_rec_id = gGeog_auth_rec_id AND
                locality.locality_id = accepted_lat_long.locality_id AND
                accepted_lat_long.orig_lat_long_units = 'degrees dec. minutes' AND
                NVL(MAXIMUM_ELEVATION,-1) = NVL(aRec.maximum_elevation,-1) AND
            	NVL(MINIMUM_ELEVATION,-1) = NVL(aRec.minimum_elevation,-1) AND
            	NVL(ORIG_ELEV_UNITS,'NULL') = NVL(aRec.orig_elev_units,'NULL') AND
            	NVL(MIN_DEPTH,-1) = nvl(aRec.min_depth,-1) AND
            	NVL(MAX_DEPTH,-1) = nvl(aRec.max_depth,-1) AND
            	NVL(SPEC_LOCALITY,'NULL') = NVL(aRec.spec_locality,'NULL') AND
            	NVL(LOCALITY_REMARKS,'NULL') = NVL(aRec.locality_remarks,'NULL') AND
            	NVL(DEPTH_UNITS,'NULL') = NVL(aRec.depth_units,'NULL') AND
                nvl(concatGeologyAttributeDetail(locality.locality_id),'NULL') = nvl(b_concatGeologyAttributeDetail(aRec.collection_object_id),'NULL') AND
            	--NVL(NOGEOREFBECAUSE,'NULL') = NVL(aRec.nogeorefbecause,'NULL');
            	-- generic latlong stuff
                NVL(datum,'NULL') = NVL(aRec.datum,'NULL') AND
            	NVL(determined_by_agent_id,-1) = nvl(determiner_id,-1) AND
            	NVL(determined_date,'1600-01-01') = NVL(to_date(aRec.determined_date),'1600-01-01') AND 
            	NVL(lat_long_ref_source,'NULL') = NVL(aRec.lat_long_ref_source,'NULL') AND 
            	NVL(lat_long_remarks,'NULL') = NVL(aRec.lat_long_remarks,'NULL')  AND 
            	NVL(max_error_distance,-1) = nvl(aRec.max_error_distance,-1) AND
            	NVL(max_error_units,'NULL') = NVL(aRec.max_error_units,'NULL') AND 
            	NVL(extent,-1) = nvl(aRec.extent,-1) AND
            	NVL(gpsaccuracy,-1) = nvl(aRec.gpsaccuracy,-1) AND
            	NVL(georefmethod,'NULL') = NVL(aRec.georefmethod,'NULL')  AND 
            	NVL(verificationstatus,'NULL') = NVL(aRec.verificationstatus,'NULL') AND 
            	-- degrees dec. minutes stuff
            	NVL(LAT_DEG,-1) = nvl(aRec.LATDEG,-1) AND
            	NVL(DEC_LAT_MIN,-1) = nvl(aRec.DEC_LAT_MIN,-1) AND
            	NVL(LAT_DIR,'NULL') = NVL(aRec.LATDIR,'NULL') AND
            	NVL(LONG_DEG,-1) = nvl(aRec.LONGDEG,-1) AND
            	NVL(DEC_LONG_MIN,-1) = nvl(aRec.DEC_LONG_MIN,-1) AND
            	NVL(LONG_DIR,'NULL') = NVL(aRec.LONGDIR,'NULL')
            ;
       ELSIF aRec.orig_lat_long_units = 'deg. min. sec.' THEN
            select 
    	        nvl(min(locality.locality_id),-1)			 
            INTO
    	        gLocalityId
            FROM 
            	locality,
            	accepted_lat_long
            WHERE
                geog_auth_rec_id = gGeog_auth_rec_id AND
                locality.locality_id = accepted_lat_long.locality_id AND
                accepted_lat_long.orig_lat_long_units = 'deg. min. sec.' AND
                NVL(MAXIMUM_ELEVATION,-1) = NVL(aRec.maximum_elevation,-1) AND
            	NVL(MINIMUM_ELEVATION,-1) = NVL(aRec.minimum_elevation,-1) AND
            	NVL(ORIG_ELEV_UNITS,'NULL') = NVL(aRec.orig_elev_units,'NULL') AND
            	NVL(MIN_DEPTH,-1) = nvl(aRec.min_depth,-1) AND
            	NVL(MAX_DEPTH,-1) = nvl(aRec.max_depth,-1) AND
            	NVL(SPEC_LOCALITY,'NULL') = NVL(aRec.spec_locality,'NULL') AND
            	NVL(LOCALITY_REMARKS,'NULL') = NVL(aRec.locality_remarks,'NULL') AND
            	NVL(DEPTH_UNITS,'NULL') = NVL(aRec.depth_units,'NULL') AND
                nvl(concatGeologyAttributeDetail(locality.locality_id),'NULL') = nvl(b_concatGeologyAttributeDetail(aRec.collection_object_id),'NULL') AND
            	--NVL(NOGEOREFBECAUSE,'NULL') = NVL(aRec.nogeorefbecause,'NULL');
            	-- generic latlong stuff
                NVL(datum,'NULL') = NVL(aRec.datum,'NULL') AND
            	NVL(determined_by_agent_id,-1) = nvl(determiner_id,-1) AND
            	NVL(determined_date,'1600-01-01') = NVL(to_date(aRec.determined_date),'1600-01-01') AND 
            	NVL(lat_long_ref_source,'NULL') = NVL(aRec.lat_long_ref_source,'NULL') AND 
            	NVL(lat_long_remarks,'NULL') = NVL(aRec.lat_long_remarks,'NULL')  AND 
            	NVL(max_error_distance,-1) = nvl(aRec.max_error_distance,-1) AND
            	NVL(max_error_units,'NULL') = NVL(aRec.max_error_units,'NULL') AND 
            	NVL(extent,-1) = nvl(aRec.extent,-1) AND
            	NVL(gpsaccuracy,-1) = nvl(aRec.gpsaccuracy,-1) AND
            	NVL(georefmethod,'NULL') = NVL(aRec.georefmethod,'NULL')  AND 
            	NVL(verificationstatus,'NULL') = NVL(aRec.verificationstatus,'NULL') AND 
            	-- deg. min. sec. stuff
            	NVL(LAT_DEG,-1) = nvl(aRec.LATDEG,-1) AND
            	NVL(LAT_MIN,-1) = nvl(aRec.LATMIN,-1) AND
            	NVL(LAT_SEC,-1) = nvl(aRec.LATSEC,-1) AND
            	NVL(LAT_DIR,'NULL') = NVL(aRec.LATDIR,'NULL') AND
            	NVL(LONG_DEG,-1) = nvl(aRec.LONGDEG,-1) AND
            	NVL(LONG_MIN,-1) = nvl(aRec.LONGMIN,-1) AND
            	NVL(LONG_SEC,-1) = nvl(aRec.LONGSEC,-1) AND
            	NVL(LONG_DIR,'NULL') = NVL(aRec.LONGDIR,'NULL')
            ;	
      ELSE
            error_msg := aRec.orig_lat_long_units || ' is not valid or handled';
			raise failed_validation;      	
     END IF; 
         IF gLocalityId > 0 THEN
            -- found a suitable locality
            l_locality_id := gLocalityId;
        ELSE
            -- no suitable locality - make one
            b_make_bulkloader_locality(collobjid);
        END IF;		
	else
		-- there's either a pre-specificed locality_id or collecting_event_id
		--dbms_output.put_line ('there is either a pre-specificed locality_id or collecting_event_id');
		SELECT collecting_event_id INTO gCollEvntId from bulkloader where collection_object_id = collobjid;
		IF nvl(length(gCollEvntId),0) = 0 THEN
		    --dbms_output.put_line ('do NOT have a collecting_event_id, see if we have a valid locality_id');
		    -- do NOT have a collecting_event_id, see if we have a valid locality_ud
		    select locality_id into gLocalityId from bulkloader where collection_object_id = collobjid;
		    select count(*)  into num from locality where locality_id=gLocalityId;
		    if num = 1 then
    			l_locality_id := gLocalityId;
    		else
    			error_msg := 'Bulkloader.locality_id does not resolve to a valid locality';
    			raise failed_validation;
    		end if;
    	ELSE
    	    --dbms_output.put_line ('DO have event ID, make sure it is a good one');
    	    select count(*)  into num from collecting_event where collecting_event_id=gCollEvntId;
    	    if num != 1 then
    		    error_msg := 'Bulkloader.collecting_event_id does not resolve to a valid collecting_event';
    			raise failed_validation;
    		end if;
    	END IF;		
	END IF; -- locid is null check
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_bulkload_locality',collobjid);
END;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_build_keys_table (collobjid IN number) 
is
rec bulkloader%ROWTYPE;
taxa_one varchar2(255);
taxa_two varchar2(255);
a_coln varchar2(255);
a_instn varchar2(255);
BEGIN
l_collection_object_id  := NULL;
l_collecting_event_id := NULL;
l_entered_person_id := NULL;
l_accn_id := NULL;
l_taxa_formula := NULL;
l_id_made_by_agent_id := NULL;
l_cat_num := NULL;
l_collection_id := NULL;
l_locality_id := NULL;
l_taxon_name_id_1 := NULL;
l_taxon_name_id_2 := NULL;
	select * into rec from bulkloader where collection_object_id=collobjid;
	select sq_collection_object_id.nextval into l_collection_object_id from dual;
	if rec.cat_num is null then
		select nvl(max(cat_num_integer),0) + 1 into l_cat_num from cataloged_item,collection		
		where cataloged_item.collection_id = collection.collection_id and
		collection.collection_cde=rec.collection_cde and 
		collection.institution_acronym = rec.institution_acronym;
	else
		select count(cat_num) into num from cataloged_item,collection
		where cataloged_item.collection_id = collection.collection_id and
		collection.collection_cde=rec.collection_cde and 
		collection.institution_acronym = rec.institution_acronym and
		cat_num=rec.cat_num;
		if num >= 1 then
			error_msg := 'cat_num already exists';
			raise failed_validation;
		else
			l_cat_num := rec.cat_num;
		end if;
	end if;
	select count(distinct(collection_id)) into num from collection where collection_cde=rec.collection_cde and
		institution_acronym = rec.institution_acronym;
	if num != 1 then
		error_msg := 'Bad collection_cde and institution_acronym';
		raise failed_validation;
	else
		select distinct(collection_id) into l_collection_id from collection where collection_cde=rec.collection_cde and
			institution_acronym = rec.institution_acronym;
	end if;
	select count(distinct(agent_id)) into num from agent_name where agent_name = rec.ENTEREDBY
		AND agent_name_type = 'login';
	if num != 1 then
		error_msg := 'Bad enteredby (use login)';
		raise failed_validation;
	else
		select distinct(agent_id) into l_entered_person_id from agent_name where agent_name = rec.ENTEREDBY
    		AND agent_name_type = 'login';
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
        a_coln := rec.collection_cde;
        a_instn := rec.institution_acronym;
        tempStr2 := rec.accn;
	END IF;
   select count(distinct(accn.transaction_id)) into num from accn,trans,collection where 
    	accn.transaction_id = trans.transaction_id and
    	trans.collection_id=collection.collection_id AND
    	collection.institution_acronym = a_instn and
    	(collection.collection_cde = a_coln or collection.collection_cde = 'MCZ') AND
    	accn_number = tempStr2;
	if num != 1 then
		error_msg := 'Bad accn: ' || rec.accn || '; COLLCDE: ' || a_coln || '; ACCNNUM: ' || tempStr2;
		raise failed_validation;
	else
		select accn.transaction_id into l_accn_id from accn,trans,collection where 
		accn.transaction_id = trans.transaction_id and
	    trans.collection_id=collection.collection_id AND
		collection.institution_acronym = a_instn and
	    (collection.collection_cde = a_coln or collection.collection_cde = 'MCZ') AND
		accn_number = tempStr2;
	end if;
	if instr(rec.taxon_name,' or ') > 1 then
		num := instr(rec.taxon_name, ' or ') -1;
		taxa_one := substr(rec.taxon_name,1,num);
		taxa_two := substr(rec.taxon_name,num+5);
		l_taxa_formula := 'A or B';
  elsif instr(rec.taxon_name,' and ') > 1 then
    num := instr(rec.taxon_name, ' and ') -1;
    taxa_one := substr(rec.taxon_name,1,num);
    taxa_two := substr(rec.taxon_name,num+6);
    l_taxa_formula := 'A and B';
	elsif instr(rec.taxon_name,' x ') > 1 then
		num := instr(rec.taxon_name, ' x ') -1;
		taxa_one := substr(rec.taxon_name,1,num);
		taxa_two := substr(rec.taxon_name,num+4);
		l_taxa_formula := 'A x B';			
	elsif  substr(rec.taxon_name,length(rec.taxon_name) - 3) = ' sp.' then
		l_taxa_formula := 'A sp.';
		taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 4);
    elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' ssp.' then
        l_taxa_formula := 'A ssp.';
        taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);
    elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' spp.' then
        l_taxa_formula := 'A spp.';
        taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);
    elsif  substr(rec.taxon_name,length(rec.taxon_name) - 8) = ' sp. nov.' then
        l_taxa_formula := 'A sp. nov.';
        taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 9);
    elsif  substr(rec.taxon_name,length(rec.taxon_name) - 9) = ' gen. nov.' then
        l_taxa_formula := 'A gen. nov.';
        taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 10);
    elsif  substr(rec.taxon_name,length(rec.taxon_name) - 7) = ' (group)' then
        l_taxa_formula := 'A (group)';
        taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 8);
    elsif  substr(rec.taxon_name,length(rec.taxon_name) - 3) = ' nr.' then
        l_taxa_formula := 'A nr.';
        taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 4);
	elsif  substr(rec.taxon_name,length(rec.taxon_name) - 3) = ' cf.' then
		l_taxa_formula := 'A cf.';
		taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 4);
  elsif  substr(rec.taxon_name,length(rec.taxon_name) - 4) = ' aff.' then
    l_taxa_formula := 'A aff.';
    taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 5);  
	elsif  substr(rec.taxon_name,length(rec.taxon_name) - 1) = ' ?' then
		l_taxa_formula := 'A ?';
		taxa_one := substr(rec.taxon_name,1,length(rec.taxon_name) - 2);
	elsif (instr(rec.taxon_name,' {') > 1 AND instr(rec.taxon_name,'}') > 1) then
		l_taxa_formula := 'A {string}';
		taxa_one := regexp_replace(rec.taxon_name,' {.*}$','');
	else
		l_taxa_formula := 'A';
		taxa_one := rec.taxon_name;
	end if;
	if taxa_two is not null AND (
		  substr(taxa_one,length(taxa_one) - 3) = ' sp.' OR
			substr(taxa_two,length(taxa_two) - 3) = ' sp.' OR
			substr(taxa_one,length(taxa_one) - 1) = ' ?' OR
			substr(taxa_two,length(taxa_two) - 1) = ' ?' 
		) then
			error_msg := '"sp." and "?" are not allowed in multi-taxon IDs';
			raise failed_validation;	
	end if;
	if taxa_one is not null then
		select count(distinct(taxon_name_id)) into num from taxonomy where scientific_name = trim(taxa_one) and VALID_CATALOG_TERM_FG = 1;
		if num = 1 then
			select distinct(taxon_name_id) into l_taxon_name_id_1 from taxonomy where scientific_name = trim(taxa_one) and VALID_CATALOG_TERM_FG = 1;
		else
			error_msg := 'taxonomy (' || taxa_one || ') not found';
			raise failed_validation;
		end if;
	end if;
	if taxa_two is not null then
		select count(distinct(taxon_name_id)) into num from taxonomy where scientific_name = trim(taxa_two) and VALID_CATALOG_TERM_FG = 1;
		if num = 1 then
			select distinct(taxon_name_id) into l_taxon_name_id_2 from taxonomy where scientific_name = trim(taxa_two) and VALID_CATALOG_TERM_FG = 1;
		else
			error_msg := 'taxonomy (' || taxa_two || ') not found';
			raise failed_validation;	
		end if;
	end if;
	select count(distinct(agent_id)) into num from agent_name where agent_name = rec.ID_MADE_BY_AGENT;
	if num != 1 then
		error_msg := 'ID_MADE_BY_AGENT (' || rec.ID_MADE_BY_AGENT || ') not found';
		raise failed_validation;
	else
		select distinct(agent_id) into l_id_made_by_agent_id from agent_name where agent_name = rec.ID_MADE_BY_AGENT;
	end if;
	if l_collection_object_id IS NULL OR
		l_entered_person_id  IS NULL OR
		l_accn_id  IS NULL OR
		l_taxon_name_id_1  IS NULL OR
		l_taxa_formula  IS NULL OR
		l_id_made_by_agent_id  IS NULL OR
		l_cat_num  IS NULL OR
		l_collection_id  IS NULL THEN
		error_msg := 'Failed to set key values at b_build_keys_table';
		raise failed_validation;
	end if;
	insert into bulkloader_attempts (
		b_collection_object_id,
 		collection_object_id,
 		tstamp 
 	) values (
 		rec.collection_object_id,
 		l_collection_object_id,
 		sysdate
 	);
 	commit;
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_build_keys_table',collobjid);
END;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE b_bulk_this is
	CURSOR rec_cursor IS
		SELECT collection_object_id, mask_record from bulkloader where loaded is null and collection_object_id > 12;
	n_collection_object_id cataloged_item.collection_object_id%TYPE;
	n_clocality_id locality.locality_id%TYPE;
	--error_msg varchar2(4000);  
	collobjid cataloged_item.collection_object_id%TYPE;
	l_loaded bulkloader.loaded%TYPE;
begin
	--b_bulk_disable;	
	FOR rec IN rec_cursor LOOP
		error_msg := NULL;
		collobjid := rec.collection_object_id;
		b_build_keys_table(collobjid);
		if error_msg is null then
			b_bulkload_locality(collobjid);
		end if;
		if error_msg is null then
			b_bulkload_coll_event(collobjid);
		end if;
		if error_msg is null then
			b_bulkload(collobjid);
		end if;
		if error_msg is null then
			b_bulkload_otherid(collobjid);
		end if;
		if error_msg is null then
			b_bulkload_parts(collobjid);
		end if;
		if error_msg is null then
			b_bulkload_attribute(collobjid);
		end if;		
		if error_msg is null then
        If rec.mask_record is not null and rec.mask_record > 0 then 
            if upper(rec.mask_record) = '1' or rec.mask_record = 'X' then 
                insert into COLL_OBJECT_ENCUMBRANCE(collection_object_id, encumbrance_id)
                values(l_collection_object_id, 95);
            else
                insert into COLL_OBJECT_ENCUMBRANCE(collection_object_id, encumbrance_id)
                values(l_collection_object_id, rec.mask_record);
            end if;
        end if;
			delete from bulkloader where collection_object_id = collobjid;
			--update bulkloader set loaded = 'spiffification complete' where collection_object_id = collobjid;
		else
			b_rollback_bulkloader (l_collection_object_id,collobjid);
		end if;	
		--b_bulk_makeflat(rec.collection_object_id);
		commit;
		/*
		select loaded into l_loaded from bulkloader where collection_object_id = collobjid;
			if l_loaded is null then
			end if;
		--b_bulk_makeflat(rec.collection_object_id);
		commit;
		*/
	end loop;
	--b_bulk_enable;
EXCEPTION
	when others then
		bulkload_error (error_msg,SQLERRM,'b_bulk_this',collobjid);
end;
---------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE check_and_load is
	num number;
begin
	-- relies on table proc_bl_status:
	-- create table proc_bl_status (status number(1));
  execute immediate 'alter session set nls_date_format = ''yyyy-mm-dd'' ';
	select count(*) into num from proc_bl_status;
	if num != 1 then
		delete from proc_bl_status;
		insert into proc_bl_status (status) values (0);
		commit;
	end if;
	select status into num from proc_bl_status;
	if num = 0 then
		-- lock this process
		update proc_bl_status set status=1;
		commit;
		bulkloader_check;
		b_bulk_this;
    BULKLOADER_LOAD_RELATIONS;
		-- update status table to indicate loading attempt complete
		update proc_bl_status set status=0;
		commit;
	end if;
end;
---------------------------------------------------------------------------------------------------------------------------------------------
END;