
  CREATE OR REPLACE FUNCTION "MEDIA_RELATION_SUMMARY" (mediaRelationsId IN number)
    return varchar2
    AS
    summary varchar2(4000);
    mr varchar2(4000);
    fkey NUMBER;
    tabl varchar2(4000);
begin
    select media_relationship,related_primary_key
     INTO mr,fkey from media_relations where media_relations_id = mediaRelationsId;
    tabl := SUBSTR(mr,instr(mr,' ',-1)+1);
     case tabl
            when 'locality' then
                select spec_locality into summary from locality where locality_id=fkey;
            when 'collecting_event' then
                select verbatim_locality || ' (' || verbatim_date || ')' into summary from collecting_event
                where collecting_event_id=fkey;
            when 'agent' then
                select agent_name into summary from preferred_agent_name where agent_id=fkey;
            when 'media' then
                select media_uri into summary from media where media_id=fkey;
            when 'permit' then
                select PERMIT_NUM into summary from permit where permit_id=fkey;
            when 'underscore_collection' then
                select collection_name into summary from underscore_collection where underscore_collection_id=fkey;
            when 'accn' then
                select accn_type into summary from accn where transaction_id=fkey;
            when 'cataloged_item' then
                select guid into summary from flat
                where
                 collection_object_id=fkey;
             when 'project' then
                select project_name into summary from project
                where
                project_id=fkey;
            when 'publication' then
                select UTL_I18N.UNESCAPE_REFERENCE(REGEXP_REPLACE(formatted_publication,'<[/a-zA-Z]+>','')) into summary
                from formatted_publication 
                where format_style = 'long' and publication_id = fkey;                
            else
                summary:='Unknown table';
        end case;

    return summary;
end;