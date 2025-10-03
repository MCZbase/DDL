
  CREATE OR REPLACE EDITIONABLE FUNCTION "Q_MEDIA_RELATIONS" (mediaID IN number)
	return varchar2
	-- returns pipe-delimited list of media relations
	-- media_relations_id|media_relationship|related_primary_key|summary_value
	AS
	the_relation varchar2(4000);
	sep varchar(6);
	tabl varchar2(38);
	theValue varchar2(4000);
begin
	for r in (select * from media_relations,preferred_agent_name where
	media_relations.created_by_agent_id=preferred_agent_name.agent_id and
	media_id=mediaID) loop
		the_relation:=the_relation || sep || r.media_relations_id || '|' || r.media_relationship;
		-- find table name
		tabl := SUBSTR(r.media_relationship,instr(r.media_relationship,' ',-1)+1);
		the_relation:=the_relation || '|' || r.related_primary_key;
		case tabl
			when 'locality' then
				select spec_locality into theValue from locality where locality_id=r.related_primary_key;
				the_relation:=the_relation || '|' ||  theValue;
			when 'collecting_event' then
				select verbatim_locality || ' (' || verbatim_date || ')' into theValue from collecting_event
				where collecting_event_id=r.related_primary_key;
				the_relation:=the_relation ||  '|' || theValue;
			when 'agent' then
				select agent_name into theValue from preferred_agent_name where agent_id=r.related_primary_key;
				the_relation:=the_relation ||  '|' || theValue;
			when 'media' then
				select media_uri into theValue from media where media_id=r.related_primary_key;
				the_relation:=the_relation ||  '|' || theValue;
			when 'cataloged_item' then
				select collection || ' ' || cat_num into theValue from cataloged_item,
				collection where
				cataloged_item.collection_id=collection.collection_id and
				 collection_object_id=r.related_primary_key;
				the_relation:=the_relation ||  '|' || theValue;
			else
				the_relation:=the_relation ||  '|' || 'Unknown table';
		end case;



				--dbms_output.put_line(r.media_relationship);
		sep := chr(10);
	end loop;
	return the_relation;
end;