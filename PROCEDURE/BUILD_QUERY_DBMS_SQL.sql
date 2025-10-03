
  CREATE OR REPLACE EDITIONABLE PROCEDURE "BUILD_QUERY_DBMS_SQL" (resultID IN varchar2, varUsername IN varchar2, searchJSON IN CLOB) 
as 

---sql statement variables
varSQL CLOB;
populateTableSQL CLOB;
varJOINS varchar2(4000);
varCONDITIONAL CLOB;
varAttributesJoin varchar2(4000);
varAccessionsJoin varchar2(4000);
varLoansJoin varchar2(4000);
varDeaccsJoin varchar2(4000);
varCollEventsJoin varchar2(4000);
varCollectorsJoin varchar2(4000);
varIdentificationsJoin varchar2(4000);
varPartsJoin varchar2(4000);
varCitationsJoin varchar2(4000);
varMediaJoin varchar2(4000);
varRelationshipsJoin varchar2(4000);
varNamedGroupsJoin varchar2(4000);
varKeywordsJoin varchar2(4000);
varTaxonomyJoin varchar2(4000);
varPublicSearch varchar2(4000);
varJoinList varchar2(4000) := 'Cataloged Items';
isCatNum boolean := false;
varJoinTerm varchar(10);

---cf_spec_search_cols variables
varTableName cf_spec_search_cols.table_name%TYPE; 
varTableAlias cf_spec_search_cols.table_alias%TYPE;
varColumnName varchar2(4000);  -- is assembled as concatentation of table and column
varSearchCategory cf_spec_search_cols.search_category%TYPE;
varDataType cf_spec_search_cols.data_type%TYPE;

x number := 0;
y number := 0;
c number;
n number;
searchTableExists number :=0;
oneOfUs number :=0;
isLocalitySearch number :=0;

cursor c1 is select * from table (make_search_terms(searchJSON));

begin

Select count(*) into oneOfUs from dba_role_privs where GRANTED_ROLE = 'COLDFUSION_USER' and grantee = upper(varUserName);

varSQL := 
  'select distinct :1 as resultID, cataloged_item.collection_object_id
  from 
  coll_object

  ---cataloged item
  join cataloged_item on coll_object.collection_object_id = cataloged_item.collection_object_id
  left outer join coll_obj_other_id_num on (cataloged_item.COLLECTION_OBJECT_ID = coll_obj_other_id_num.COLLECTION_OBJECT_ID)
  left outer join coll_object_remark  on (cataloged_item.collection_object_id = coll_object_remark.COLLECTION_OBJECT_ID)';

varAttributesJoin := 
  '
  ---attributes
  left outer join attributes on (cataloged_item.collection_object_id = attributes.collection_object_id)';

varAccessionsJoin :=
  '
  ---accession
  join accn on (cataloged_item.ACCN_ID = accn.transaction_id)
  join trans accn_trans on (accn.transaction_id=accn_trans.transaction_id)
  left outer join trans_agent accn_agents on (accn_trans.transaction_id = accn_agents.transaction_id) 
  left outer join agent_name accn_names on (accn_agents.agent_id = accn_names.AGENT_ID)'; 

varLoansJoin :=
  '
  ---loan
  join specimen_part loan_part on (cataloged_item.collection_object_id = loan_part.DERIVED_FROM_CAT_ITEM)
  left outer join loan_item on (loan_part.collection_object_id = loan_item.collection_object_id)
  left outer join loan on (loan_item.transaction_id=loan.transaction_id)
  left outer join trans loan_trans on (loan_item.transaction_id=loan_trans.transaction_id)
  left outer join trans_agent loan_agents on (loan_trans.transaction_id = loan_agents.transaction_id) 
  left outer join agent_name loan_names on (loan_agents.agent_id = loan_names.AGENT_ID)';

varDeaccsJoin :=
  '
  ---deaccession
  join specimen_part deacc_part on (cataloged_item.collection_object_id = deacc_part.DERIVED_FROM_CAT_ITEM)
  left outer join deacc_item on (deacc_part.collection_object_id = deacc_item.collection_object_id)
  left outer join deaccession on (deacc_item.transaction_id=deaccession.transaction_id)
  left outer join trans deacc_trans on (deacc_item.transaction_id=deacc_trans.transaction_id)
  left outer join trans_agent deacc_agents on (deacc_trans.transaction_id = deacc_agents.transaction_id) 
  left outer join agent_name deacc_names on (deacc_agents.agent_id = deacc_names.AGENT_ID)';  

varCollEventsJoin :=
  '
  ---collecting_event
  join collecting_event on (cataloged_item.collecting_event_id = collecting_event.collecting_event_id)
  left outer join coll_event_number on (collecting_event.collecting_event_id = coll_event_number.collecting_event_id)
  ---locality
  join locality on (collecting_event.locality_id = locality.locality_id)
  join geog_auth_rec on (locality.geog_auth_rec_id = geog_auth_rec.GEOG_AUTH_REC_ID)
  left outer join lat_long on (locality.locality_id = lat_long.locality_id)
  left outer join GEOLOGY_ATTRIBUTES on (locality.locality_id = geology_attributes.locality_id)';

varCollectorsJoin :=  
  '
  ---collectors
  left outer join collector on (cataloged_item.collection_object_id = collector.collection_object_id)
  left outer join agent collector_agent on (collector.agent_id = collector_agent.agent_id)
  left outer join person collector_person on (collector_agent.agent_id = collector_person.person_id)
  left outer join agent_name collector_agent_name on (collector.agent_id=collector_agent_name.agent_id)';

varIdentificationsJoin := 
  '
  ---identifications
  join identification on (cataloged_item.collection_object_id = identification.collection_object_id)
  join identification_taxonomy on (identification.identification_id = identification_taxonomy.identification_id)
  join IDENTIFICATION_agent on (identification.identification_id = identification_agent.identification_id)
  join agent_name identifier_name on (identification_agent.agent_id=identifier_name.agent_id)
  join taxonomy on (identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id)
  left outer join common_name on (taxonomy.taxon_name_id = common_name.taxon_name_id)';

varPartsJoin := 
  '
  ---parts
  left outer join specimen_part on (cataloged_item.collection_object_id = specimen_part.DERIVED_FROM_CAT_ITEM)
  left outer join coll_object specimen_part_object on (specimen_part.collection_object_id = specimen_part_object.collection_object_id)
  left outer join coll_object_remark specimen_part_remarks on (specimen_part.collection_object_id = specimen_part_remarks.COLLECTION_OBJECT_ID)
  left outer join SPECIMEN_PART_ATTRIBUTE on (specimen_part.collectioN_object_id = SPECIMEN_PART_ATTRIBUTE.COLLECTION_OBJECT_ID)';

varCitationsJoin :=
  '
  ---citations
  left outer join citation on (cataloged_item.collection_object_id=citation.collection_object_id)
  left outer join taxonomy citation_taxonomy on (citation.CITED_TAXON_NAME_ID = citation_taxonomy.taxon_name_id)
  left outer join ctcitation_type_status on (citation.type_status = ctcitation_type_status.type_status)
  left outer join formatted_publication citation_form_publication on (citation.publication_id = citation_form_publication.publication_id)';

varMediaJoin := 
  '
  ---media
  left outer join media_relations on (media_relations.related_primary_key = cataloged_item.collection_object_id and media_relationship = ''shows cataloged_item'')
  left outer join media on (media_relations.media_id = media.media_id)
  left outer join media_labels on (media.media_id = media_labels.media_id)
  left outer join media_relations next_media_relation on (media.media_id = next_media_relation.media_id)
  left outer join media_relations creator_media_relation on (media.media_id = creator_media_relation.media_id and creator_media_relation.media_relationship = ''created by agent'')';

varRelationshipsJoin :=

  '
  ---relationships
  left outer join view_all_relations BIOL_INDIV_RELATIONS on (cataloged_item.collection_object_id = BIOL_INDIV_RELATIONS.collection_object_id)';

varNamedGroupsJoin := 
  '---named groups
  left outer join underscore_relation on (cataloged_item.collection_object_id = underscore_relation.collection_object_id)
  left outer join underscore_collection on (underscore_collection.UNDERSCORE_COLLECTION_ID = underscore_relation.UNDERSCORE_COLLECTION_ID)';

varKeywordsJoin := 
  '---Keywords
  join flat on (cataloged_item.collection_object_id = flat.collection_object_id)'; 

varTaxonomyJoin :=
  '---Taxonomy
  join taxa_terms on (cataloged_item.collection_object_id = taxa_terms.collection_object_id)
  join taxa_terms_all on (cataloged_item.collection_object_id = taxa_terms_all.collection_object_id)';

---join to limit public searches to FILTERED_FLAT  
varPublicSearch :=
  '---FilteredFlat
  join filtered_flat on (cataloged_item.collection_object_id = filtered_flat.collection_object_id)';

---build where clause (add loop after test)
for c1_rec in c1 loop

-- dbms_output.put_line(c1_rec.searchfield);

--  for varColumnName to match in joins, set to table_alias.column_name 
select table_name, table_alias, table_alias || '.' || column_name, search_category, data_type into
  varTableName, varTableAlias, varColumnName, varSearchCategory, varDataType 
  from cf_spec_search_cols
  where column_alias = upper(c1_rec.searchfield);

case varSearchCategory
  when 'Attributes' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varAttributesJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Accessions' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varAccessionsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Loans' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varLoansJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;    
  when 'Deaccessions' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varDeaccsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;      
  when 'Collecting Events' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varCollEventsJoin;
      varJoinList := varJoinList || varSearchCategory;
      isLocalitySearch := 1;
    end if;
  when 'Collectors' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varCollectorsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Identifications' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varIdentificationsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Specimen Parts' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varPartsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Citations' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varCitationsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Media' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varMediaJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Relationships' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varRelationshipsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Named Groups' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varNamedGroupsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Keywords' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varKeywordsJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  when 'Taxonomy' then
    if instr(varJoinList,varSearchCategory)=0 then
      varJOINS := varJOINS || varTaxonomyJoin;
      varJoinList := varJoinList || varSearchCategory;
    end if;
  else
    NULL;
end case;

If oneOfUs = 0 then 
  varJoinList := varJoinList || varPublicSearch;
end if;

---build conditionals

---check to see if this is the catalog number
varJoinTerm := c1_rec.joinfield;

if c1_rec.searchfield like 'CAT_NUM%' then
    if not isCatNum then
        varJoinTerm :=  varJoinTerm || ' ( ';
        isCatNum := true;
    end if;
else
    if isCatNum then
        varConditional := varConditional || ' ) ';
        isCatNum := false;
    end if;
end if;

if c1_rec.searchTerm = 'NULL' THEN
   varConditional := varConditional || ' ' || varJoinTerm || ' ' || varColumnName || ' IS NULL ';
elsif c1_rec.searchTerm = 'NOT NULL' THEN
   varConditional := varConditional || ' ' || varJoinTerm || ' ' || varColumnName || ' IS NOT NULL ';
else 
    --  TODO: obtain join from SearchTermsRecord and use it to choose use of and/or clauses, and parenthetical phrases around or clauses
    case varDataType
    when 'CLOB' THEN
        RAISE_APPLICATION_ERROR(-20100,'Search on fields with data type of CLOB not supported yet.',TRUE);
    when 'DATE' THEN
        if REGEXP_LIKE(c1_rec.searchTerm, '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
            if c1_rec.comparator = '=' then 
                -- search for a day, where date may contain times
                varConditional := varConditional || ' ' || varJoinTerm  || ' to_char(' || varColumnName || ',''yyyy-mm-dd'') = :bnd' || x || ' ' ;
            elsif c1_rec.comparator = '>=' then 
                varConditional := varConditional || ' ' || varJoinTerm  || ' ' || varColumnName || ' >= to_date( :bnd' || x || ', ''yyyy-mm-dd'')' ;     
            elsif c1_rec.comparator = '<=' then 
                varConditional := varConditional || ' ' || varJoinTerm  || ' ' || varColumnName || ' <= to_date( :bnd' || x || ', ''yyyy-mm-dd'')' ;            
            else 
                RAISE_APPLICATION_ERROR(-20101,'Search other than =, <=, >= on yyyy-mm-dd for fields with data type of DATE not supported yet.',TRUE);
            end if;
        elsif REGEXP_LIKE(c1_rec.searchTerm, '^[0-9]{4}-[0-9]{2}-[0-9]{2}/[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN    
            varConditional := varConditional || ' ' || varJoinTerm  || ' ' || varColumnName || ' BETWEEN to_date( :bnd' || x || ', ''yyyy-mm-dd'') and to_date( :bnda' || x || ', ''yyyy-mm-dd'')+INTERVAL ''1'' DAY - INTERVAL ''1'' SECOND' ;            
        elsif  REGEXP_LIKE(c1_rec.searchTerm, '^[0-9]{4}$') THEN  
            varConditional := varConditional || ' ' || varJoinTerm  || ' ' || varColumnName || ' BETWEEN to_date( :bnd' || x || ', ''yyyy-mm-dd'') and to_date( :bnda' || x || ', ''yyyy-mm-dd'')+INTERVAL ''1'' DAY - INTERVAL ''1'' SECOND' ;
        else 
            RAISE_APPLICATION_ERROR(-20102,'Search other than on yyyy-mm-dd for fields with data type of DATE not supported yet.',TRUE);
        end if;
    when 'NUMBER' THEN
        if upper(c1_rec.comparator) = 'IN' then 
            varConditional := varConditional || ' ' || varJoinTerm || ' ' || varColumnName || ' IN (' || ':bnd' || x;
            FOR Y in 1..regexp_count(c1_rec.searchTerm, ',')
                LOOP
                X:=X+1;
                varConditional := varConditional || ',:bnd' || x;
                END LOOP;
            varConditional := varConditional || ')';
        else
            varConditional := varConditional || ' ' || varJoinTerm || ' ' || varColumnName || ' ' || c1_rec.comparator || ' ' || ':bnd' || x;
        end if;
    when 'CHAR' THEN
        if upper(c1_rec.comparator) = 'LIKE' then
            varConditional := varConditional || ' ' || varJoinTerm || ' upper(' || varColumnName || ') ' || c1_rec.comparator || ' upper(''%''||' || ':bnd' || x || '||''%'')';
        elsif c1_rec.comparator = '=' then 
            varConditional := varConditional || ' ' || varJoinTerm  || ' upper(' || varColumnName || ') = upper(' || ':bnd' || x || ')';       
        elsif upper(c1_rec.comparator) = 'IN' then 
            varConditional := varConditional || ' ' || varJoinTerm || ' ' || varColumnName || ' IN (' || ':bnd' || x;
            FOR Y in 1..regexp_count(c1_rec.searchTerm, ',')
                LOOP
                X:=X+1;
                varConditional := varConditional || ',:bnd' || x;
                END LOOP;
            varConditional := varConditional || ')';          
        else    
            varConditional := varConditional || ' ' || varJoinTerm || ' ' || varColumnName || ' ' || c1_rec.comparator || ' ' || ':bnd' || x ;
        end if;
    when 'VARCHAR2' THEN
        if upper(c1_rec.comparator) = 'LIKE' then
            varConditional := varConditional || ' ' || varJoinTerm || ' upper(' || varColumnName || ') ' || c1_rec.comparator || ' upper(''%''||' || ':bnd' || x || '||''%'')';
        elsif upper(c1_rec.comparator) = 'NOT LIKE' then
            varConditional := varConditional || ' ' || varJoinTerm || ' upper(' || varColumnName || ') ' || c1_rec.comparator || ' upper(''%''||' || ':bnd' || x || '||''%'')';
        elsif c1_rec.comparator = '=' then 
            varConditional := varConditional || ' ' || varJoinTerm || ' upper(' || varColumnName || ') = upper(' || ':bnd' || x || ')';
        elsif upper(c1_rec.comparator) = 'SOUNDEX' then 
            varConditional := varConditional || ' ' || varJoinTerm || ' soundex(' || varColumnName || ') = soundex(' || ':bnd' || x || ')';   
        elsif upper(c1_rec.comparator) = 'JARO_WINKLER' then
            -- TODO: Returns zero matches
            varConditional := varConditional || ' ' || varJoinTerm || ' (utl_match.jaro_winkler_similarity(' || varColumnName || ', ' || ':bnd' || x || ') >= 80) ';  
        elsif upper(c1_rec.comparator) = 'IN' then 
            varConditional := varConditional || ' ' || varJoinTerm || ' ' || varColumnName || ' IN (' || ':bnd' || x;
            FOR Y in 1..regexp_count(c1_rec.searchTerm, ',')
                LOOP
                X:=X+1;                
                varConditional := varConditional || ',:bnd' || x;
                END LOOP;
            varConditional := varConditional || ')';         
        else    
            varConditional := varConditional || ' ' || varJoinTerm || ' ' || varColumnName || ' ' || c1_rec.comparator || ' ' || ':bnd' || x ;
        end if;
    when 'CTXKEYWORD' THEN
        varConditional := varConditional || ' ' || varJoinTerm || ' contains(' || varColumnName || ', :bnd' || x || ', 1) > 0';
    END CASE;
END IF;

If oneOfUs = 0 and isLocalitySearch = 1 then 
    varConditional := varConditional || ' and coll_object.collection_object_id not in 
        (select coll_object_encumbrance.collection_object_id
        from coll_object_encumbrance, encumbrance
        where coll_object_encumbrance.encumbrance_id = encumbrance.encumbrance_id
        and encumbrance.encumbrance_action = ''mask locality'')';
end if;

x := x + 1;
end loop;
varSQL := varSQL || varJOINS || ' WHERE 1=1 ' || varConditional;

populateTableSQL := 'insert into ' || varusername || '.user_search_table (result_id, collection_object_id, pagesort) 
                    select resultID, collection_object_id, rownum from (' || varSQL || ')';

---was the last search term a catalog number? If so...add a closing ')'
if isCatNum then populateTableSQL := populateTableSQL || ')'; end if;

dbms_output.put_line(populateTableSQL);

x := 0;

c := dbms_sql.open_cursor;

-- raise_application_error(-20002,'['|| varSQL ||  ']');

DBMS_SQL.PARSE(c, populateTableSQL, dbms_sql.native);
dbms_sql.BIND_VARIABLE(c, ':1', resultID);

for c1_rec in c1 loop
    if c1_rec.searchTerm = 'NULL' OR c1_rec.searchTerm = 'NOT NULL' THEN
        dbms_output.put_line('skipping bind for null ' || x || ' ' || c1_rec.searchTerm);
    else    
        select data_type into varDataType 
            from cf_spec_search_cols
            where column_alias = upper(c1_rec.searchfield);
        if c1_rec.comparator = 'IN' then 
          ---dbms_output.put_line(':bnd' || x || ' ' || c1_rec.searchTerm);
            If varDataType in ('CHAR', 'VARCHAR2') then 
              FOR Y in 1..regexp_count(c1_rec.searchTerm, ',')+1 LOOP
                dbms_sql.BIND_VARIABLE(c, ':bnd' || x, split(c1_rec.searchTerm,Y,','));
                dbms_output.put_line(':bnd' || x || ' ' || split(c1_rec.searchTerm,Y,','));
                x:=x+1;
              END LOOP;
                x:=x-1;
            elsif varDataType = 'NUMBER' then
              Y:=0;
              FOR Y in 1..regexp_count(c1_rec.searchTerm, ',')+1 LOOP
                dbms_sql.BIND_VARIABLE(c, ':bnd' || x, split(c1_rec.searchTerm,Y,','));
                dbms_output.put_line(':bnd' || x || ' ' || split(c1_rec.searchTerm,Y,','));
                x:=x+1;
              END LOOP;
              x:=x-1;
            else
              dbms_output.put_line('varDataType for ' || x || ' of ' || varDataType || ' not a recognized type for bind array for IN ' );
              RAISE_APPLICATION_ERROR(-20103,'Trying to bind an IN for a not yet supported split to array type.',TRUE);
            end if;
        else 
           if varDataType = 'DATE' and REGEXP_LIKE(c1_rec.searchTerm, '^[0-9]{4}$') THEN
              dbms_output.put_line(':bnd' || x || ' ' || c1_rec.searchTerm || '-01-01');
              dbms_output.put_line(':bnda' || x || ' ' || c1_rec.searchTerm || '-12-31');
              dbms_sql.BIND_VARIABLE(c, ':bnd' || x, c1_rec.searchTerm || '-01-01');
              dbms_sql.BIND_VARIABLE(c, ':bnda' || x, c1_rec.searchTerm || '-12-31');
           elsif varDataType = 'DATE' AND REGEXP_LIKE(c1_rec.searchTerm, '^[0-9]{4}-[0-9]{2}-[0-9]{2}/[0-9]{4}-[0-9]{2}-[0-9]{2}$') THEN
              dbms_output.put_line(':bnd' || x || ' ' || regexp_substr(c1_rec.searchTerm,'[^/]+',1,1));
              dbms_output.put_line(':bnda' || x || ' ' || regexp_substr(c1_rec.searchTerm,'[^/]+',1,2));
              dbms_sql.BIND_VARIABLE(c, ':bnd' || x, regexp_substr(c1_rec.searchTerm,'[^/]+',1,1));
              dbms_sql.BIND_VARIABLE(c, ':bnda' || x, regexp_substr(c1_rec.searchTerm,'[^/]+',1,2));          
           else
              dbms_output.put_line(':bnd' || x || ' ' || c1_rec.searchTerm);
              dbms_sql.BIND_VARIABLE(c, ':bnd' || x, to_char(c1_rec.searchTerm));
           end if;
        end if;
    end if;    
    x := x+1;
end loop;

n := dbms_sql.execute(c);
dbms_sql.close_cursor(c);


end;