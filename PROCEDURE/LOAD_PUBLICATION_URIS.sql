
  CREATE OR REPLACE EDITIONABLE PROCEDURE "LOAD_PUBLICATION_URIS" as

numMEDIAID number;
num number;

cursor c1 is select x.media_uri, p.publication_id, p.publication_title from x_ent_antcite_uri x, publication p where x.publication_id = p.publication_id and media_uri is not null;

begin
for c1_rec in c1 loop

            select count(*) into num from media where media_uri = c1_rec.media_uri;

            if num = 1 then
                select media_id into numMEDIAID from media where media_uri = c1_rec.media_uri;
            else
                insert into media(media_uri, mime_type, media_type, preview_uri)
                values(trim(c1_rec.media_uri), 'text/html', 'text', null)
                returning media_id into numMEDIAID;
            end if;

            select count(*) into num from media_relations where media_id = numMEDIAID and media_relationship = 'shows publication' and related_primary_key = c1_rec.publication_id;

            if num = 0 then 
                insert into media_relations(media_id, media_relationship, created_by_agent_id, related_primary_key)
                values(numMEDIAID, 'shows publication', 0, c1_rec.publication_id);
            end if;

            select count(*) into num from media_labels where media_id = numMEDIAID and media_label = 'description' and label_value = c1_rec.publication_title;

            if num = 0 then

                insert into media_labels(media_id, media_label, label_value, assigned_by_agent_id)
                values(numMEDIAID, 'description', trim(c1_rec.publication_title), 0);
            end if;

end loop;
end;