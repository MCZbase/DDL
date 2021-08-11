
  CREATE OR REPLACE PROCEDURE "BULK_LEP_DETERMINATIONS_BF" is

--  Backfill - try bulk_lep_determinations for cases where error is not null.
--
--  Copy additional determinations from DataShot (lepidoptera schema) into MCZbase 
--  for records that have had been brought to state specialist reviewed and then
--  successfully ingested into MCZbase via bulkloader_lepidoptera.  Since the DataShot
--  schema supports and identification history, but the bulkloader does not, determination
--  history needs to be loaded separately.  
--  Determinations may be abbreviated and placed as text under an appropriate higher taxon.
--  Progress of the full load is tracked in bulkloader_lepidoptera_map and in flags in 
--  the Specimen table.
  
  CURSOR c1 is select specimenid from bulkloader_lepidoptera_map where imagesloaded = 1 and deterloaded=0 and error is not null;

---default cursor
  CURSOR c2(collobjid IN NUMBER) IS 
  select * from dets_for_load@lepidoptera where specimenid=collobjid and (scientific_name is not null or verbatim_text is not null);

---use edited names 
  /*CURSOR c2(collobjid IN NUMBER) IS 
  select d.specimenid, d.nature_of_id, d.accepted_id_fg, f.edited_name as scientific_name  
  from dets_for_load@lepidoptera d, fixlepdeter f
  where d.scientific_name=f.tax_history_scientific_name
  and f.edited_name <> 'good'
  and d.specimenid = collobjid;*/

  taxa_one varchar2(255);
  taxa_two varchar2(255);
  det_id_1 mczbase.taxonomy.taxon_name_id%type;
  det_id_2 mczbase.taxonomy.taxon_name_id%type;
  d_taxa_formula varchar2(20);
  someRandomString varchar2(4000);
  someRandomNumber number;
  num number;
  failed_validation exception;
  error_msg varchar2(1000);
  l_collection_object_id mczbase.coll_object.collection_object_id%type;
  numspecimenid number;
  placehoder_sciname mczbase.taxonomy.scientific_name%type;
  numagentid mczbase.agent.agent_id%type;
  agentcnt number;



  begin

  for c1_rec in c1 loop
  numspecimenid:= c1_rec.specimenid;
  select distinct collection_object_id into l_collection_object_id from bulkloader_lepidoptera_map where specimenid = numspecimenid;
  begin
    For c2_rec in c2(numspecimenid) LOOP
      somerandomstring := null;

  If c2_rec.Verbatim_Text is not null then

    --  Select min(taxon_name_id) into det_id_1 from taxonomy where scientific_name = 'Insecta';
    --  Look up a plausible higher taxon to hang the verbatim text off of.
    select min(taxon_name_id) into det_id_1 from taxonomy 
       where scientific_name 
          in (select nvl(decode(family,'Formicidae',family,phylorder),'Insecta') 
                from identification i 
                left join identification_taxonomy it on i.identification_id = it.identification_id 
                left join taxonomy t on it.taxon_name_id = t.taxon_name_id 
              where accepted_id_fg = 1 
              and collection_object_id = l_collection_object_id
              and rownum < 2 
          );

    select sq_identification_id.nextval into someRandomNumber from dual;
    select scientific_name into somerandomstring from taxonomy where taxon_name_id = det_id_1;
    insert into identification (
            IDENTIFICATION_ID,
            COLLECTION_OBJECT_ID,
            NATURE_OF_ID,
            made_date,
            ACCEPTED_ID_FG,
            TAXA_FORMULA,
            SCIENTIFIC_NAME,
            IDENTIFICATION_REMARKS
          ) values (
            someRandomNumber,
            l_collection_object_id,
            c2_rec.NATURE_OF_ID,
            nvl(to_date(c2_rec.dateidentified, 'YYYY-MM-DD'), null),
            0,
            'A',
            somerandomstring,
            c2_rec.concatenatedremarks
          );
    insert into identification_taxonomy (
            IDENTIFICATION_ID,
            TAXON_NAME_ID,
            VARIABLE
          ) values (
            someRandomNumber,
            det_id_1,
            'A'
          );

  Else
      taxa_one := '';
      taxa_two := '';
      if instr(c2_rec.scientific_name,' or ') > 1 then
        num := instr(c2_rec.scientific_name, ' or ') -1;
        taxa_one := substr(c2_rec.scientific_name,1,num);
        taxa_two := substr(c2_rec.scientific_name,num+5);
        d_taxa_formula := 'A or B';
      elsif instr(c2_rec.scientific_name,' and ') > 1 then
        num := instr(c2_rec.scientific_name, ' and ') -1;
        taxa_one := substr(c2_rec.scientific_name,1,num);
        taxa_two := substr(c2_rec.scientific_name,num+5);
        d_taxa_formula := 'A and B';
      elsif instr(c2_rec.scientific_name,' x ') > 1 then
        num := instr(c2_rec.scientific_name, ' x ') -1;
        taxa_one := substr(c2_rec.scientific_name,1,num);
        taxa_two := substr(c2_rec.scientific_name,num+4);
        d_taxa_formula := 'A x B';			
      elsif  substr(c2_rec.scientific_name,length(c2_rec.scientific_name) - 3) = ' sp.' then
        d_taxa_formula := 'A sp.';
        taxa_one := substr(c2_rec.scientific_name,1,length(c2_rec.scientific_name) - 3);
      elsif  substr(c2_rec.scientific_name,length(c2_rec.scientific_name) - 3) = ' cf.' then
        d_taxa_formula := 'A cf.';
        taxa_one := substr(c2_rec.scientific_name,1,length(c2_rec.scientific_name) - 3);
      elsif  substr(c2_rec.scientific_name,length(c2_rec.scientific_name) - 1) = ' ?' then
        d_taxa_formula := 'A ?';
        taxa_one := substr(c2_rec.scientific_name,1,length(c2_rec.scientific_name) - 1);
      elsif (instr(c2_rec.scientific_name,' {') > 1 AND instr(c2_rec.scientific_name,'}') > 1) then
        d_taxa_formula := 'A {string}';
        taxa_one := regexp_replace(c2_rec.scientific_name,' {.*}$','');
      else
        d_taxa_formula := 'A';
        taxa_one := c2_rec.scientific_name;
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
        select count(distinct(taxon_name_id)) into num from taxonomy where scientific_name = trim(taxa_one);
        if num = 1 then
          select distinct(taxon_name_id) into det_id_1 from taxonomy where scientific_name = trim(taxa_one);
        else
          error_msg := 'taxonomy (' || taxa_one || ') not found';
          raise failed_validation;
        end if;
      end if;
      if taxa_two is not null then
        select count(distinct(taxon_name_id)) into num from taxonomy where scientific_name = trim(taxa_two) and VALID_CATALOG_TERM_FG = 1;
        if num = 1 then
          select distinct(taxon_name_id) into det_id_2 from taxonomy where scientific_name = trim(taxa_two) and VALID_CATALOG_TERM_FG = 1;
        else
          error_msg := 'taxonomy (' || taxa_two || ') not found';
          raise failed_validation;	
        end if;
      end if;

      select sq_identification_id.nextval into someRandomNumber from dual;
        IF (instr(c2_rec.scientific_name,' {') > 1 AND instr(c2_rec.scientific_name,'}') > 1) then
        someRandomString := regexp_replace(c2_rec.scientific_name,'^.* {(.*)}$','\1');
        ELSE
            someRandomString:=c2_rec.scientific_name;
        END IF;

          insert into identification (
            IDENTIFICATION_ID,
            COLLECTION_OBJECT_ID,
            NATURE_OF_ID,
            made_date,
            ACCEPTED_ID_FG,
            TAXA_FORMULA,
            SCIENTIFIC_NAME
          ) values (
            someRandomNumber,
            l_collection_object_id,
            c2_rec.NATURE_OF_ID,
            nvl(to_date(c2_rec.dateidentified, 'YYYY-MM-DD'), null),
            0,
            d_taxa_formula,
            someRandomString
          );

          insert into identification_taxonomy (
            IDENTIFICATION_ID,
            TAXON_NAME_ID,
            VARIABLE
          ) values (
            someRandomNumber,
            det_id_1,
            'A'
          );
          if det_id_2 is not null then
            insert into identification_taxonomy (
              IDENTIFICATION_ID,
              TAXON_NAME_ID,
              VARIABLE
            ) values (
              someRandomNumber,
              det_id_2,
              'B'
            );
          end if;

    end if;

    select count(*) into agentcnt from agent_name where agent_name = c2_rec.id_made_by_agent;

    if agentcnt = 1 then 
      select agent_id into numagentid from agent_name where agent_name = c2_rec.id_made_by_agent;
    else
      error_msg := 'agent (' || c2_rec.id_made_by_agent || ') not found';
      raise failed_validation;	
    end if;

    insert into identification_agent(identification_id, agent_id, identifier_order)
    values(someRandomNumber, numagentid, 1);

    end loop;

  update bulkloader_lepidoptera_map set deterloaded = 1, error = null where specimenid = numspecimenid;
  commit;

  EXCEPTION
    when failed_validation then 
      rollback;
      update bulkloader_lepidoptera_map set error=error_msg where specimenid = numspecimenid;
      commit;
    when others then
      rollback;
      update bulkloader_lepidoptera_map set error='determinations error ' || DBMS_UTILITY.FORMAT_ERROR_STACK() where specimenid = numspecimenid;
      commit;
  END;
  end loop;

EXCEPTION
  when failed_validation then 
    rollback;
		update bulkloader_lepidoptera_map set error=error_msg where specimenid = numspecimenid;
    commit;
	when others then
		rollback;
		update bulkloader_lepidoptera_map set error='determinations error ' || DBMS_UTILITY.FORMAT_ERROR_STACK()  where specimenid = numspecimenid;
    commit;
END;