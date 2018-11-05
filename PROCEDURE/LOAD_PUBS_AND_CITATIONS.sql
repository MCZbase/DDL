
  CREATE OR REPLACE PROCEDURE "LOAD_PUBS_AND_CITATIONS" as

numpublication_id number;
numauthor1_id number;
numauthor2_id number;
numauthor3_id number;
numauthor4_id number;
numauthor5_id number;
numauthor6_id number;
numauthor7_id number;
numauthor8_id number;
numauthor9_id number;
numauthor10_id number;
ERR_NUM NUMBER(5); 
err_msg VARCHAR2(513); 
num number;
failed_validation exception;
numCITEDTAXA number;
numCOLLOBJID number;
numMEDIAID number;
debug_step varchar2(100);

cursor loadpubs is select * from CF_TEMP_PUB_AND_CITATIONS where loaded is null;

begin

for c1_rec in loadpubs

loop

  begin
    err_msg := null;
    
    select count(*) into num from publication where upper(publication_title) = upper(trim(c1_rec.publication_title));
  
    If num > 1 then 
      err_msg := err_msg || 'more than one publication with this title already exists;';
      raise failed_validation;
    elsif num = 1 then
      debug_step := 'fetching existing publication id';
      select publication_id into numpublication_id from publication where upper(publication_title) = upper(trim(c1_rec.publication_title));
    else
      debug_step := 'creating publication';
      select sq_publication_id.nextval into numpublication_id from dual;
    
      insert into publication(publication_id, publication_type, publication_title, published_year, publication_remarks, is_peer_reviewed_fg)
      values (numpublication_id, c1_rec.publication_type, c1_rec.publication_title, c1_rec.published_year, c1_rec.publication_remarks, 1);
    
      if c1_rec.author1 is not null then
        debug_step := 'fetching author1 ID';
        select agent_name_id into numauthor1_id from agent_name where agent_name = c1_rec.author1;
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor1_id, 1, 'author');
      end if;
    
      if c1_rec.author2 is not null then
        debug_step := 'fetching author2 ID';
        select agent_name_id into numauthor2_id from agent_name where agent_name = c1_rec.author2;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor2_id, 2, 'author'); 
      END IF;
    
      if c1_rec.author3 is not null then
      debug_step := 'fetching author3 ID';
        select agent_name_id into numauthor3_id from agent_name where agent_name = c1_rec.author3;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor3_id, 3, 'author'); 
      END IF;
      
      if c1_rec.author4 is not null then
      debug_step := 'fetching author4 ID';
        select agent_name_id into numauthor4_id from agent_name where agent_name = c1_rec.author4;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor4_id, 4, 'author'); 
      END IF;
      
       if c1_rec.author5 is not null then
        debug_step := 'fetching author5 ID';
        select agent_name_id into numauthor5_id from agent_name where agent_name = c1_rec.author5;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor5_id, 5, 'author'); 
      END IF;
    
      /*if c1_rec.author6 is not null then
      debug_step := 'fetching author6 ID';
        select agent_name_id into numauthor6_id from agent_name where agent_name = c1_rec.author6;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor6_id, 6, 'author'); 
      END IF;
      
      if c1_rec.author7 is not null then
      debug_step := 'fetching author7 ID';
        select agent_name_id into numauthor7_id from agent_name where agent_name = c1_rec.author7;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor7_id, 7, 'author'); 
      END IF;
      
      if c1_rec.author8 is not null then
      debug_step := 'fetching author8 ID';
        select agent_name_id into numauthor8_id from agent_name where agent_name = c1_rec.author8;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor8_id, 8, 'author'); 
      END IF;
      
      if c1_rec.author9 is not null then
      debug_step := 'fetching author9 ID';
        select agent_name_id into numauthor9_id from agent_name where agent_name = c1_rec.author9;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor9_id, 9, 'author'); 
      END IF;
      
      
      if c1_rec.author10 is not null then
      debug_step := 'fetching author10 ID';
        select agent_name_id into numauthor10_id from agent_name where agent_name = c1_rec.author10;
        
        insert into publication_author_name(publication_id, agent_name_id, author_position, author_role)
        values(numpublication_id, numauthor10_id, 10, 'author'); 
      END IF;*/
      
      
      if c1_rec.publication_type = 'journal article' then
        if c1_rec.journal_name is not null then 
        debug_step := 'inserting journal name';
          insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
          values(numpublication_id, 'journal name', trim(c1_rec.journal_name));
        end if;
      end if;

      if c1_rec.publication_type = 'serial monograph' then
        if c1_rec.journal_name is not null then 
        debug_step := 'inserting journal name';
          insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
          values(numpublication_id, 'journal name', trim(c1_rec.journal_name));
        end if;
      end if;
      
      if c1_rec.publication_type = 'book section' then
        if c1_rec.journal_name is not null then 
        debug_step := 'inserting book name';
          insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
          values(numpublication_id, 'book', trim(c1_rec.journal_name));
        end if;
      end if;
    
      /*if c1_rec.series is not null then 
        insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
        values(numpublication_id, 'series', c1_rec.series);
      end if;*/

      if c1_rec.VOLUME is not null then 
        debug_step := 'inserting volume';
        insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
        values(numpublication_id, 'volume', c1_rec.VOLUME);
      end if;
      if c1_rec.ISSUE is not null then
      debug_step := 'inserting issue';
        insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
        values(numpublication_id, 'issue', c1_rec.ISSUE);
      end if;
      if c1_rec.NUM is not null then 
      debug_step := 'inserting number';
        insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
        values(numpublication_id, 'number', c1_rec.NUM);
      end if;
      if c1_rec.BEGIN_PAGE is not null then 
      debug_step := 'inserting begin page';
        insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
        values(numpublication_id, 'begin page', c1_rec.BEGIN_PAGE);
      end if;
      if c1_rec.END_PAGE is not null then 
      debug_step := 'inserting end page';
        insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
        values(numpublication_id, 'end page', c1_rec.END_PAGE);
      end if;
      /*if c1_rec.TOTAL_PAGES is not null then 
        insert into publication_attributes(publication_id, publication_attribute, pub_att_value)
        values(numpublication_id, 'page total', c1_rec.TOTAL_PAGES);
      end if;*/
      
      -- attach media
      debug_step := 'attaching media';
          if c1_rec.media_uri is not null then
            select count(*) into num from media where media_uri = c1_rec.media_uri;
            
            if num = 1 then
                select media_id into numMEDIAID from media where media_uri = c1_rec.media_uri;
            else
                insert into media(media_uri, mime_type, media_type, preview_uri)
                values(c1_rec.media_uri, 'text/html', 'text', c1_rec.preview_uri)
                returning media_id into numMEDIAID;
            end if;
            
            insert into media_relations(media_id, media_relationship, created_by_agent_id, related_primary_key)
            values(numMEDIAID, 'shows publication', 0, numpublication_id);
            
            insert into media_labels(media_id, media_label, label_value, assigned_by_agent_id)
            values(numMEDIAID, 'description', c1_rec.publication_title, 0);
          end if;
    end if;
    
    update CF_TEMP_PUB_AND_CITATIONS set publication_id = numpublication_id, error=null where ID = c1_rec.id;
    
--deal with citations
    if c1_rec.cat_num is not null then
      debug_step := 'getting cited taxon_id for ' || c1_rec.cited_as;
      select taxon_name_id into numCITEDTAXA from taxonomy where scientific_name = c1_rec.cited_as;
      debug_step := 'getting collection_object_id for ' || c1_rec.cat_num;
      select collection_object_id into numCOLLOBJID from cataloged_item where cat_num = c1_rec.cat_num and collection_cde = c1_rec.collection_cde;
      
      debug_step := 'inserting citation';
      insert into citation(publication_id, collection_object_id, cited_taxon_name_id, cit_current_fg, occurs_page_number, type_status, citation_remarks)
      values(numpublication_id, numCOLLOBJID, numCITEDTAXA, 1, c1_rec.occurs_page_number, c1_rec.type_status, c1_rec.citation_remarks); 
    end if;
    
    update CF_TEMP_PUB_AND_CITATIONS set loaded = 'Y', error = null where ID = c1_rec.id;
    commit;
    
    EXCEPTION
    
      WHEN FAILED_VALIDATION THEN
       ROLLBACK;
       UPDATE CF_TEMP_PUB_AND_CITATIONS SET error = err_msg WHERE ID=c1_rec.ID;
       COMMIT;
  
       WHEN OTHERS THEN
       ROLLBACK;
       err_num := SQLCODE;
       err_msg := SUBSTR(SQLERRM, 1, 512);
       UPDATE CF_TEMP_PUB_AND_CITATIONS SET error = err_num || ': ' || err_msg || ' while ' || debug_step WHERE ID=c1_rec.ID;
       COMMIT;
  end;
  null;  
  end loop;
build_formatted_pub; 
end;