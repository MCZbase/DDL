
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_TITLE" (mediaID IN number, itemizeLedger in number default 0)
return varchar2
-- Given a media_id, return a textual description of the media object suitable for use as the title for the image
-- for the image.
-- 
-- @param mediaID the media_id of the media object for which to return a title
-- @param itemizeLedger if 0 default, then only list first and last cataloged item for a ledger, if 1 list all cataloged items for ledger.
-- @see get_media_descriptor() for ac:description or alt text.
AS
    type rc is ref cursor;
	the_relation varchar2(4000);
	sep varchar(6);
	tabl varchar2(38);
    theLabel varchar2(255);
	theValue varchar2(4000);
    media_type varchar2(255);
    ledgeraccumulator varchar2(4000);
    ledgerprefix varchar2(255);
    firstledger varchar2(255);
    lastledger varchar2(255);
    ledgercounter number;
    maxlengthpart number;
    l_cur    rc;
begin

    open l_cur for 
    'select media_type from media where media_id = :x '
    using mediaID;
    fetch l_cur into media_type;
    close l_cur;

    dbms_output.put_line(media_type);

    the_relation := ' ';
    sep :=' ';
    ledgercounter := 0; 
    ledgeraccumulator := ' ';
    ledgerprefix := '';

    maxlengthpart := 2000;

	for r in (
       select media_relationship, related_primary_key from media_relations where 
	   media_id=mediaID
    ) loop
         if (r.media_relationship = 'ledger entry for cataloged_item' and  ledgercounter = 0) then
             if (length(the_relation) + length(sep) < 3968) then
                ledgerprefix := '<dfn>Ledger Entry for</dfn>: ';
             end if;
        end if;
		-- find table name
		tabl := SUBSTR(r.media_relationship,instr(r.media_relationship,' ',-1)+1);
        select label into theLabel from ctmedia_relationship where r.media_relationship = ctmedia_relationship.media_relationship;
		--the_relation:=the_relation || '; table: ' || tabl;

       dbms_output.put_line('1: ['|| the_relation || ']');

       dbms_output.put_line(tabl);

		case tabl
            when 'deaccession' then 
                select nvl(deacc_number, 'no number') || '. ' into theValue from deaccession where transaction_id = r.related_primary_key;
                the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: '  || theValue;
            when 'borrow'  then 
                select nvl(borrow_number, 'no number') || ' ' into theValue from borrow where transaction_id = r.related_primary_key;
                the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: '  || theValue;     
            when 'accn'  then 
                select  accn_number || '. Received on ' || received_date || '. ' into theValue from accn where transaction_id = r.related_primary_key;
                the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: ' || theValue;     
            when 'loan'  then 
                select nvl2(loan_number, ' ' || loan_number || ' ', ' ') || nvl2(loan_status, ' <dfn>Status:</dfn> ' || loan_status || '. ', ' ') into theValue from loan where transaction_id = r.related_primary_key;
                the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: '  || theValue;                  
            when 'permit'  then 
                select nvl2(permit_num, ' ' || permit_num || ' ', ' ') || permit_type || nvl2(issued_date, '. Issued Date: ' || issued_date || ' ', ' ') || permit_title into theValue from permit where permit_id = r.related_primary_key;
                the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: ' || theValue;     
			when 'underscore_collection' then
				select  nvl(collection_name, '[no name]') || '' into theValue from underscore_collection where underscore_collection_id=r.related_primary_key;
                 if length(theValue) > maxlengthpart then 
                    theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                 end if;
				 the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: '  || theValue;                   
			when 'publication' then
                begin
        			select formatted_publication into theValue 
                    from publication left join formatted_publication on publication.publication_id = formatted_publication.publication_id
                    where publication.publication_id=r.related_primary_key
                       and formatted_publication.format_style = 'short';

                    if length(theValue) > maxlengthpart then 
                        theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                    end if;  
                    if  (length(the_relation) + length(theLabel) +  length(theValue) < 3975) then 
                        the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: ' || theValue;     
                    end if;                        
                exception -- catch
                when NO_DATA_FOUND then 
                       dbms_output.put_line('NO_DATA_FOUND no short formatted pubulication found' );
                end; -- end try/catch           
			when 'locality' then
                begin 
        			select nvl2(spec_locality, ' ' || spec_locality || ' ', ' ') into theValue from locality where locality_id=r.related_primary_key;
                    if length(theValue) > maxlengthpart then 
                        theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                    end if;
                    if  (length(the_relation) + length(theLabel) +  length(theValue) < 3975) then 
                        the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: '  || theValue;
                    end if;
                exception -- catch
                when NO_DATA_FOUND then 
                    dbms_output.put_line('NO_DATA_FOUND no locality found' );
                end; -- end try/catch            
            when 'collecting_event' then
                begin
				select verbatim_locality || ' (' || verbatim_date || ')' into theValue from collecting_event
				where collecting_event_id=r.related_primary_key;
                    if length(theValue) > maxlengthpart then 
                        theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                    end if;    
                    if  (length(the_relation) + length(theLabel) +  length(theValue) < 3975) then 
                        the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: '  || theValue;
                    end if;                 
                exception -- catch
                when NO_DATA_FOUND then 
                    dbms_output.put_line('NO_DATA_FOUND no locality found' );
                end; -- end try/catch             
            when 'agent' then
				select agent_name into theValue from preferred_agent_name where agent_id=r.related_primary_key;
                if(r.media_relationship = 'created by agent') then 
                select '' into theValue from dual;
                end if;
                if(r.media_relationship <> 'created by agent') then 
                     the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: '  || theValue || ' '; 
                end if;
            when 'media' then
				select media_id into theValue from media where media_id=r.related_primary_key;
				the_relation:=the_relation ||'<dfn>' || theLabel || '</dfn>: ' || theValue;                
            when 'cataloged_item' then
                if (r.media_relationship = 'ledger entry for cataloged_item') then
                    ledgercounter := ledgercounter + 1;
                end if;

                dbms_output.put_line('relatedpk=' || r.related_primary_key );

                begin  -- try      
    				select  guid || ' ' || scientific_name || ' ' || nvl2(toptypestatus, ' ' || toptypestatus || '', ' ') into theValue 
                    from MCZBASE.filtered_flat  
                    where collection_object_id=r.related_primary_key;

                    dbms_output.put_line('2');

                    if (theValue is not null) then
                        dbms_output.put_line('3: [' || theValue || ']');
                        if length(theValue) > maxlengthpart then 
                            theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
                        end if;
                        if  r.media_relationship = 'ledger entry for cataloged_item' then 
                           if itemizeLedger = 1 then
                                if length(ledgeraccumulator) +  length(theValue) < 3997 then
                                    ledgeraccumulator :=  ledgeraccumulator || '<br>' || trim(theValue) || ' ';
                                    dbms_output.put_line('ledger: [' || ledgeraccumulator || ']');
                                end if;
                           else 
                               if ledgercounter = 1 then
                                    firstledger :=  ' ' || trim(theValue) || ' ';
                               else 
                                    lastledger :=  ' ' || trim(theValue) || ' ';
                               end if;
                           end if;
                        end if;
                        if  (length(the_relation) +  length(theValue) < 3950 and (r.media_relationship <> 'ledger entry for cataloged_item')) then 
                           the_relation:= the_relation || '<dfn>' || theLabel || '</dfn>: '|| theValue || ' ';
                        end if;
                    end if;
                    dbms_output.put_line('4: [' || the_relation || ']');

                exception -- catch
                when NO_DATA_FOUND then 
                       dbms_output.put_line('NO_DATA_FOUND cataloged_item not in filtered flat' );
                end; -- end try/catch

                dbms_output.put_line('5: [' || the_relation || ']');


            when 'specimen_part' then
				select ' -'|| part_name || '- ' into theValue 
                from MCZBASE.filtered_flat  
                left join specimen_part on specimen_part.derived_from_cat_item = MCZBASE.filtered_flat.collection_object_id
                where specimen_part.collection_object_id=r.related_primary_key;
                begin -- try
                    if (theValue is not null) then 
                       if  (length(the_relation) + length(theLabel) +  length(theValue) < 3975) then 
                           the_relation:= the_relation ||'<dfn>' || theLabel || '</dfn>: '  || theValue || ' ';
                       end if;
                    end if;
                exception -- catch
                when NO_DATA_FOUND then 
                       dbms_output.put_line('NO_DATA_FOUND part not in filtered flat' );
                end; -- end try/catch                    
            else
				the_relation:=the_relation || ' Unknown table: ' || tabl || ' (PKEY: ' || r.related_primary_key || ')';
		end case;
        if (r.media_relationship <> 'created by agent') then
		   sep := ' ';
        end if;
        if (r.media_relationship = 'shows cataloged_item') then
           sep := '';
        end if;
        if (r.media_relationship = 'ledger entry for cataloged_item') then
           sep := '';
        end if;

         dbms_output.put_line('loop: ' || the_relation);

	end loop;

    if ledgercounter > 0 then 
       if itemizeLedger = 1 then
            theValue := ledgerprefix || ledgercounter || ' cataloged items ' || ledgeraccumulator;
       else 
          if ledgercounter > 1 then
              theValue := ledgerprefix || ledgercounter || ' cataloged items from' || firstledger || 'to' || lastledger;
          else 
              theValue := ledgerprefix || firstledger;
          end if;
       end if;
       if length(theValue) > maxlengthpart then 
         theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
       end if;
       if  (length(the_relation) +  length(theValue) < 3974) then 
          the_relation:=the_relation || ' ' || theValue;
       end if;
    end if; 

    dbms_output.put_line('loop done: ' || the_relation);

    select mczbase.get_medialabel(media_id, 'description') into theValue from media where media_id=mediaID;
    if (theValue is not null) then 
       if length(theValue) > maxlengthpart then 
         theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
       end if;
       if  (length(the_relation) +  length(theValue) < 3974) then 
          the_relation:=the_relation || ' <dfn>Description</dfn>: ' || theValue;
       end if;
    end if;

    dbms_output.put_line('6: ' || the_relation);

    select mczbase.get_medialabel(media_id, 'aspect') into theValue from media where media_id=mediaID;
    if (theValue is not null) then 
        if theValue is not null and length(theValue) > maxlengthpart then 
            theValue:= substr(theValue,0,maxlengthpart-length(theValue)-4) || '... ';
        end if;
        if  (length(the_relation) +  length(theValue) < 3978) then 
            the_relation := the_relation  || ' <dfn>Aspect</dfn>: ' || theValue;   
        end if;
	end if;

    dbms_output.put_line('7: [' || the_relation ||']');

    if (the_relation is null or the_relation = ' ') then 
        the_relation := 'Media of type ' || media_type || ' with no description available.';
    end if;

    dbms_output.put_line('8: [' || the_relation || ']');

    return trim(the_relation);
end;