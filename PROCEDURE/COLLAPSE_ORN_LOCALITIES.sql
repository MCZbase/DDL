
  CREATE OR REPLACE EDITIONABLE PROCEDURE "COLLAPSE_ORN_LOCALITIES" as


cursor c1 is select  min(l.locality_id) locality_id, l.geog_auth_rec_id, l.SPEC_LOCALITY, round(ll.dec_lat,1) dec_lat, round(ll.dec_long,1) dec_long, l.MINIMUM_ELEVATION, l.MAXIMUM_ELEVATION, l.ORIG_ELEV_UNITS, l.LOCALITY_REMARKS, ll.VERIFICATIONSTATUS, l.SOVEREIGN_NATION
from X_CLOSE_ORN_LOCALITIES x, LOCALITY l, accepted_lat_long ll 
where x.LOCALITY_ID = l.LOCALITY_ID
and l.locality_id = ll.locality_id
and x.GEOREFMETHOD <> 'GPS'
and l.locality_id not in
(select locality_id from flat where collection_cde <> 'Orn')
group by  l.geog_auth_rec_id, l.SPEC_LOCALITY, round(ll.dec_lat,1), round(ll.dec_long,1), l.MINIMUM_ELEVATION, l.MAXIMUM_ELEVATION, l.ORIG_ELEV_UNITS, l.LOCALITY_REMARKS, ll.VERIFICATIONSTATUS, l.SOVEREIGN_NATION
having count(*) > 1;

numCOllEvents number;

begin
execute immediate 'alter trigger TR_COLLEVENT_AU_FLAT disable';
for c1_rec in c1 loop

select count(*) into numCollEvents from collecting_event where locality_id <> c1_rec.locality_id and locality_id in
  (select l.locality_id from locality l, accepted_lat_long ll 
    where l.locality_id = ll.locality_id
    and c1_rec.geog_auth_rec_id = l.geog_auth_rec_id
    and c1_rec.spec_locality = l.spec_locality
    and round(c1_rec.dec_lat,1) = round(ll.dec_lat,1)
    and round(c1_rec.dec_long,1) = round(ll.dec_long,1)
    and nvl(c1_rec.MINIMUM_ELEVATION,-99999) = nvl(l.MINIMUM_ELEVATION,-99999)
    and nvl(c1_rec.MAXIMUM_ELEVATION,-99999) = nvl(l.MAXIMUM_ELEVATION,-99999)
    and nvl(c1_rec.LOCALITY_REMARKS, 'xxx') = nvl(l.LOCALITY_REMARKS, 'xxx')
    and c1_rec.VERIFICATIONSTATUS=ll.VERIFICATIONSTATUS
    and c1_rec.SOVEREIGN_NATION=l.SOVEREIGN_NATION
    and l.locality_id not in
    (select locality_id from flat where collection_cde <> 'Orn'));
    
insert into x_collapsed_localities(locality_id)
select l.locality_id from locality l, accepted_lat_long ll 
    where l.locality_id = ll.locality_id
    and c1_rec.geog_auth_rec_id = l.geog_auth_rec_id
    and c1_rec.spec_locality = l.spec_locality
    and round(c1_rec.dec_lat,1) = round(ll.dec_lat,1)
    and round(c1_rec.dec_long,1) = round(ll.dec_long,1)
    and nvl(c1_rec.MINIMUM_ELEVATION,-99999) = nvl(l.MINIMUM_ELEVATION,-99999)
    and nvl(c1_rec.MAXIMUM_ELEVATION,-99999) = nvl(l.MAXIMUM_ELEVATION,-99999)
    and nvl(c1_rec.LOCALITY_REMARKS, 'xxx') = nvl(l.LOCALITY_REMARKS, 'xxx')
    and c1_rec.VERIFICATIONSTATUS=ll.VERIFICATIONSTATUS
    and c1_rec.SOVEREIGN_NATION=l.SOVEREIGN_NATION
    and l.locality_id not in
    (select locality_id from flat where collection_cde <> 'Orn');


dbms_output.put_line('updating ' || numCollEvents || ' collecting events with locality_id ' || c1_rec.locality_id);

update collecting_event set locality_id = c1_rec.locality_id where locality_id <> c1_rec.locality_id and locality_id in
  (select l.locality_id from locality l, accepted_lat_long ll 
    where l.locality_id = ll.locality_id
    and c1_rec.geog_auth_rec_id = l.geog_auth_rec_id
    and c1_rec.spec_locality = l.spec_locality
    and round(c1_rec.dec_lat,1) = round(ll.dec_lat,1)
    and round(c1_rec.dec_long,1) = round(ll.dec_long,1)
    and nvl(c1_rec.MINIMUM_ELEVATION,-99999) = nvl(l.MINIMUM_ELEVATION,-99999)
    and nvl(c1_rec.MAXIMUM_ELEVATION,-99999) = nvl(l.MAXIMUM_ELEVATION,-99999)
    and nvl(c1_rec.LOCALITY_REMARKS, 'xxx') = nvl(l.LOCALITY_REMARKS, 'xxx')
    and c1_rec.VERIFICATIONSTATUS=ll.VERIFICATIONSTATUS
    and c1_rec.SOVEREIGN_NATION=l.SOVEREIGN_NATION
    and l.locality_id not in
    (select locality_id from flat where collection_cde <> 'Orn'));
commit;

end loop;
execute immediate 'alter trigger TR_COLLEVENT_AU_FLAT enable';

---delete lat_long where locality_id in (select locality_id from X_COLLAPSED_LOCALITIES) and locality_id not in (select locality_id from collecting_event);

---delete locality where locality_id in (select locality_id from X_COLLAPSED_LOCALITIES) and locality_id not in (select locality_id from collecting_event);
commit;

end;