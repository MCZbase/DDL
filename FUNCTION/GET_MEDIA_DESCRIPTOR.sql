
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_DESCRIPTOR" (mediaID IN number)
return varchar2
-- Given a media_id, return a textual description of the media object suitable for use as the ac:description or an alt tag
-- for the image.
-- 
-- @param mediaID the media_id of the media object for which to return a description
AS
    type rc is ref cursor;
	the_relation varchar2(4000);
	sep varchar(6);
	tabl varchar2(38);
    theLabel varchar2(255);
	theValue varchar2(4000);
    media_type varchar2(255);
    ledgercounter number;
    maxlengthpart number;
    l_cur    rc;
begin

  
    open l_cur for 
    'select media_type from media where media_id = :x '
    using mediaID;
    fetch l_cur into media_type;
    close l_cur;

    the_relation := 'Media type: ' || media_type || '; ';
    
    ledgercounter := 0; 
    
    maxlengthpart := 2000;
    
    sep := '';
    
	for r in (
       select media_relationship, related_primary_key from media_relations where media_id=mediaID
    ) loop
        if (r.media_relationship = 'ledger entry for cataloged_item' and  ledgercounter > 0) then
           if (length(the_relation) + length(sep) < 3999) then
              the_relation:=the_relation || sep || ' ';
           end if;
        else 
           if (r.media_relationship <> 'created by agent') then
              if  (length(the_relation) + length(sep) + length(r.media_relationship) < 3998) then 
		         the_relation:=the_relation || ' ' || r.media_relationship || ' ';
              end if;
           end if;
        end if;
		-- find table name
		tabl := SUBSTR(r.media_relationship,instr(r.media_relationship,' ',-1)+1);
        select label into theLabel from ctmedia_relationship where r.media_relationship = ctmedia_relationship.media_relationship;
		--the_relation:=the_relation || '; table: ' || tabl;
		case tabl
           when 'deaccession' then 
                select nvl(deacc_number, 'no number') || '; ' into theValue from deaccession where transaction_id = r.related_primary_key;
                the_relation:=the_relation || theValue;
            when 'borrow'  then 
                select nvl(borrow_number, 'no number') || '' into theValue from borrow where transaction_id = r.related_primary_key;
                the_relation:=the_relation || theValue|| '; ';    
            when 'accn'  then 
                select accn_number || '. Received on ' || received_date || '; ' into theValue from accn where transaction_id = r.related_primary_key;
                the_relation:=the_relation || theValue|| ' ';    
            when 'loan'  then 
                select nvl2(loan_number, loan_number || '', '') || nvl2(loan_status, ' Status: ' || loan_status || '', '') into theValue from loan where transaction_id = r.related_primary_key;
                the_relation:=the_relation || theValue|| '; ';                  
            when 'permit'  then 
                select  nvl(permit_num || ' ', ' ') || permit_type || nvl2(issued_date, '. Issued Date: ' || issued_date || '', ' ') || permit_title into theValue from permit where permit_id = r.related_primary_key;
                the_relation:=the_relation || theValue|| '; ';                        
			when 'locality' then
				select  nvl(spec_locality, '[no specific locality data]') || '' into theValue from locality where locality_id=r.related_primary_key;
                 if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                 end if;
				the_relation:=the_relation || 'Locality: ' || theValue ||'; ';
			when 'underscore_collection' then
				select  nvl(collection_name, '[no name]') || '' into theValue from underscore_collection where underscore_collection_id=r.related_primary_key;
                 if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                 end if;
				the_relation:=the_relation || 'Named Group: ' || theValue ||'; ';                
			when 'collecting_event' then
				select nvl(verbatim_locality, '[no verbatim locality data]') || ' (' || verbatim_date || ');' into theValue from collecting_event
				where collecting_event_id=r.related_primary_key;
                if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                 end if;            
				the_relation:=the_relation || theValue|| ' ';
            when 'agent' then
				select agent_name || '; ' into theValue from preferred_agent_name where agent_id=r.related_primary_key;
                if(r.media_relationship = 'created by agent') then 
                select ' ' into theValue from dual;
                end if;
                the_relation:=the_relation || ' ' || theValue;  
            when 'publication' then
				select formatted_publication into theValue 
                from publication left join formatted_publication on publication.publication_id = formatted_publication.publication_id
                where publication.publication_id=r.related_primary_key
                   and formatted_publication.format_style = 'short';
                if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                 end if;
				the_relation:=the_relation || theValue;  
            when 'specimen_part' then
				   select specimen_part.part_name into theValue 
                   from cataloged_item, specimen_part 
                   where cataloged_item.collection_object_id=specimen_part.derived_from_cat_item and
                   specimen_part.collection_object_id=r.related_primary_key;                
                if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                end if;
                if  (length(the_relation) +  length(theValue) < 3500) then 
                    the_relation:=the_relation || theValue|| '; ';  
                end if;
            when 'media' then
				select media_id into theValue from media where media_id=r.related_primary_key;
				the_relation:=the_relation || theValue|| '; '; 
            when 'cataloged_item' then
             if (ledgercounter > 0)  then
			  	   select  cat_num into theValue 
                   from cataloged_item, collection 
                   where cataloged_item.collection_id=collection.collection_id and
                   collection_object_id=r.related_primary_key;                  
                else 
				   select collection || ' ' || cat_num into theValue 
                   from cataloged_item, collection 
                   where cataloged_item.collection_id=collection.collection_id and
                   collection_object_id=r.related_primary_key;                
                end if;
                if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                end if;
                if  (length(the_relation) +  length(theValue) < 3500) then 
                    the_relation:=the_relation || theValue;   
                end if;
                ledgercounter := ledgercounter + 1;
            when 'cataloged_item' then    
				select  guid || ' ' || scientific_name || ' ' || nvl2(toptypestatus, '' || toptypestatus || '; ', ' ') into theValue 
                from MCZBASE.filtered_flat  
                where collection_object_id=r.related_primary_key;
                if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                end if;
                if  (length(the_relation) +  length(theValue) < 3500) then 
		           the_relation:=the_relation || theValue;
                end if;
            else
				the_relation:=the_relation || ' Unknown table: ' || tabl || ' (PKEY: ' || r.related_primary_key || ')';
		end case;
         if (r.media_relationship <> 'created by agent') then
		   sep :='; ';
        end if;
	end loop;
    select mczbase.get_medialabel(media_id, 'description') into theValue from media where media_id=mediaID;
    if (theValue is not null) then 
       if length(theValue) > maxlengthpart then 
         theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
       end if;
       if  (length(the_relation) +  length(theValue) < 3986) then 
          the_relation := the_relation || ' Description: ' || theValue || '; ';
       end if;
    end if;
    select mczbase.get_medialabel(media_id, 'aspect') into theValue from media where media_id=mediaID;
    if length(theValue) > maxlengthpart then 
        theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
    end if;
    if (theValue is not null) then 
        if  (length(the_relation) +  length(theValue) < 3989) then 
            the_relation := the_relation  || ' Aspect: ' || theValue;   
        end if;
	end if;
    return trim(the_relation);
end;