
  CREATE OR REPLACE PROCEDURE "LOAD_SHAPES" as

/*---load county shapes
cursor c1 is 
    select r.geog_auth_rec_id, c.geoid
from 
    (select c.geoid, s.name state, c.name county from gis_us_states s, gis_us_counties c where s.statefp = c.statefp) c left outer join geog_auth_rec r on (c.state = r.state_prov and c.county = r.county)
        where r.island is null
        and r.continent_ocean = 'North America'
        and feature is null
        and r.island_group is null
        and r.geog_auth_rec_id is not null
        and r.wkt_polygon is null;*/
---load state shapes
cursor c1 is 
    select r.geog_auth_rec_id, c.geoid
from 
    (select c.geoid, s.name state from gis_us_states s, gis_us_states c where s.statefp = c.statefp) c left outer join geog_auth_rec r on (c.state = r.state_prov)
        where r.island is null
        and r.continent_ocean = 'North America'
        and feature is null
        and r.island_group is null
        and r.county is null
        and r.geog_auth_rec_id is not null
        and r.wkt_polygon is null;

wktshape clob;
v_sql varchar2(1000);

begin
execute immediate 'alter trigger TR_GEOGAUTHREC_AU_FLAT disable';
execute immediate 'alter trigger TRG_MK_HIGHER_GEOG disable';
for c1_rec in c1 loop
    select sdo_util.to_wktgeometry(shape) into wktshape from gis_us_states where geoid = c1_rec.geoid;
    v_sql := 'update geog_auth_rec set wkt_polygon = :1 where geog_auth_rec_id = :2';
    execute immediate v_sql using wktshape,c1_rec.geog_auth_rec_id;
    commit;
end loop;
execute immediate 'alter trigger TRG_MK_HIGHER_GEOG enable';
execute immediate 'alter trigger TR_GEOGAUTHREC_AU_FLAT enable';
end;