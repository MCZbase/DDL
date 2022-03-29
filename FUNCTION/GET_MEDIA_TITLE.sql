
  CREATE OR REPLACE FUNCTION "GET_MEDIA_TITLE" (mediaID IN number)
return varchar2
-- Given a media_id, return a textual description of the media object suitable for use as the title for the image
-- for the image.
-- 
-- @param mediaID the media_id of the media object for which to return a title
-- @see get_media_descriptor() for ac:description or alt text.
AS
    type rc is ref cursor;
	the_relation varchar2(4000);
	sep varchar(6);
	tabl varchar2(38);
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

    the_relation := ' ';
    
    ledgercounter := 0; 
    
    maxlengthpart := 2000;
    
	for r in (
       select media_relationship, related_primary_key from media_relations where
	   media_id=mediaID
    ) loop
        if (r.media_relationship = 'ledger entry for cataloged_item' and  ledgercounter > 0) then
           if (length(the_relation) + length(sep) < 3999) then
              the_relation:=the_relation || sep ;
           end if;
        else 
           if (r.media_relationship <> 'created by agent') then
              if  (length(the_relation) + length(sep) + length(r.media_relationship) < 3998) then 
		         the_relation:=the_relation || sep || r.media_relationship || '. ';
              end if;
           end if;
        end if;
		-- find table name
		tabl := SUBSTR(r.media_relationship,instr(r.media_relationship,' ',-1)+1);
		--the_relation:=the_relation || '; table: ' || tabl;
		case r.media_relationship
            when 'documents deaccession' then 
                select ' Number: ' || nvl(deacc_number, 'no number') || '. ' into theValue from deaccession where transaction_id = r.related_primary_key;
                the_relation:=the_relation || theValue;
            when 'documents borrow'  then 
                select ' Number: ' || nvl(borrow_number, 'no number') || '. ' into theValue from borrow where transaction_id = r.related_primary_key;
                the_relation:=the_relation || theValue;     
            when 'documents accn'  then 
                select 'Number: ' || accn_number || '. Received on ' || received_date || '. ' into theValue from accn where transaction_id = r.related_primary_key;
                the_relation:=the_relation || theValue;     
            when 'documents loan'  then 
                select nvl2(loan_number, ' Number: ' || loan_number || ' ', ' ') || nvl2(loan_status, 'Status: ' || loan_status || '. ', ' ') into theValue from loan where transaction_id = r.related_primary_key;
                the_relation:=the_relation || theValue;                  
            when 'shows permit'  then 
                select nvl2(permit_num, ' Number: ' || permit_num || ' ', ' ') || permit_type || nvl2(issued_date, '. Issued Date:' || issued_date || ' ', ' ') || permit_title into theValue from permit where permit_id = r.related_primary_key;
                the_relation:=the_relation || theValue;     
            when 'document for permit'  then 
                select nvl2(permit_num, ' Number: ' || permit_num || ' ', ' ')  || permit_type || nvl2(issued_date, '. Issued Date:' || issued_date || ' ', ' ')  || permit_title into theValue from permit where permit_id = r.related_primary_key;
                the_relation:=the_relation || theValue;    
			when 'shows publication' then
				select formatted_publication into theValue 
                from publication left join formatted_publication on publication.publication_id = formatted_publication.publication_id
                where publication.publication_id=r.related_primary_key
                   and formatted_publication.format_style = 'short';
                if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                 end if;
				the_relation:=the_relation || theValue;                
			when 'shows locality' then
				select nvl2(spec_locality, ' Locality: ' || spec_locality || ' ', ' ') into theValue from locality where locality_id=r.related_primary_key;
                 if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                 end if;
				the_relation:=the_relation || theValue;
			when 'shows collecting_event' then
				select verbatim_locality || ' (' || verbatim_date || ')' into theValue from collecting_event
				where collecting_event_id=r.related_primary_key;
                if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                 end if;            
				the_relation:=the_relation || theValue;
            when 'created by agent' then
               -- skip
               select '' into theValue from dual;
			when 'shows agent' then
				select agent_name into theValue from preferred_agent_name where agent_id=r.related_primary_key;
				the_relation:=the_relation || theValue;
			when 'shows handwriting of agent' then
				select agent_name into theValue from preferred_agent_name where agent_id=r.related_primary_key;
				the_relation:=the_relation || 'shows handwriting of ' || theValue;   
			when 'documents agent' then
				select agent_name into theValue from preferred_agent_name where agent_id=r.related_primary_key;
				the_relation:=the_relation || 'shows document concerning ' || theValue;                 
            when 'physical object created by agent' then
				select agent_name into theValue from preferred_agent_name where agent_id=r.related_primary_key;
				the_relation:=the_relation || 'physical object shown by the image was created by ' || theValue;                
			when 'media' then
				select media_uri into theValue from media where media_id=r.related_primary_key;
				the_relation:=the_relation || theValue;
            when 'transcript of audio media' then
				select media_uri into theValue from media where media_id=r.related_primary_key;
				the_relation:=the_relation || 'transcript for audio file ' || theValue;                
			when 'ledger entry for cataloged_item' then
                if (ledgercounter = 0)  then
				   select collection into theValue 
                   from cataloged_item, collection 
                   where cataloged_item.collection_id=collection.collection_id and
                   collection_object_id=r.related_primary_key;      
                   if length(theValue) > maxlengthpart then 
                      theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                   end if;
                   if (length(the_relation) +  length(theValue) < 3500) then 
                      the_relation:=the_relation || 'ledger page for ' || theValue;   
                   end if;
                end if;
                ledgercounter := ledgercounter + 1;
			when 'shows cataloged_item' then
				select  guid || ' ' || scientific_name || '' || nvl2(toptypestatus, ' ' || toptypestatus || '. ', '. ') into theValue 
                from MCZBASE.filtered_flat  
                where collection_object_id=r.related_primary_key;
                if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                end if;
                if  (length(the_relation) +  length(theValue) < 3500) then 
		           the_relation:=the_relation || theValue;
                end if;  
            else
				the_relation:=the_relation || 'Unknown table: ' || tabl || ' (PKEY: ' || r.related_primary_key || ')';
		end case;
        if (r.media_relationship <> 'created by agent') then
		   sep := '';
        end if;
        if (r.media_relationship = 'shows cataloged_item') then
           sep := '';
        end if;
        if (r.media_relationship = 'ledger entry for cataloged_item') then
           sep := '';
        end if;
	end loop;
    select mczbase.get_medialabel(media_id, 'description') into theValue from media where media_id=mediaID;
    if (theValue is not null) then 
       if length(theValue) > maxlengthpart then 
         theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
       end if;
       if  (length(the_relation) +  length(theValue) < 3986) then 
          the_relation := the_relation || '. Description: ' || theValue;
       end if;
    end if;
    select mczbase.get_medialabel(media_id, 'aspect') into theValue from media where media_id=mediaID;
    if length(theValue) > maxlengthpart then 
        theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
    end if;
    if (theValue is not null) then 
        if  (length(the_relation) +  length(theValue) < 3989) then 
            the_relation := the_relation  || '. Aspect: ' || theValue;   
        end if;
	end if;
    return trim(the_relation);
end;