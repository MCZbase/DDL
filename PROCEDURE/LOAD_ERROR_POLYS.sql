
  CREATE OR REPLACE PROCEDURE "LOAD_ERROR_POLYS" as

---load error shapes

cursor c1 is 
    select x.locality_id, ll.lat_long_id from x_geolocate_VP x, lat_long ll where glpoly is not null and ll.error_polygon is null and x.locality_id = ll.locality_id
    and ll.lat_long_ref_source like 'GEOLocate batch%' and length(x.glpoly) < 200000;


wktshape clob;
v_sql varchar2(1000);

begin
execute immediate 'alter trigger LAT_LONG_VERIFIEDBY_CHECK disable';
execute immediate 'alter trigger LAT_LONG_CT_CHECK disable';
execute immediate 'alter trigger TR_LATLONG_ACCEPTED_BIUPA disable';
execute immediate 'alter trigger UPDATECOORDINATES disable';
execute immediate 'alter trigger TR_LATLONG_AIUD_FLAT disable';
for c1_rec in c1 loop
    select 'POLYGON ((' || regexp_replace(regexp_replace(glpoly,'([^,]*),([^,]*)[,]{0,1}','\2 \1,'), ',$', '') || '))' into wktshape from x_geolocate_VP where locality_id = c1_rec.locality_id;
    v_sql := 'update lat_long set error_polygon = :1 where lat_long_id = :2';
    execute immediate v_sql using wktshape,c1_rec.lat_long_id;
    commit; 
end loop;
execute immediate 'alter trigger LAT_LONG_VERIFIEDBY_CHECK enable';
execute immediate 'alter trigger LAT_LONG_CT_CHECK enable';
execute immediate 'alter trigger TR_LATLONG_ACCEPTED_BIUPA enable';
execute immediate 'alter trigger UPDATECOORDINATES enable';
execute immediate 'alter trigger TR_LATLONG_AIUD_FLAT enable';
end;