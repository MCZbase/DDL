
  CREATE OR REPLACE PROCEDURE "UPDATE_CAT_ITEM_COUNTS" as
--  update the cf_geog_cat_item_counts table used to provide counts for specimen browse

begin

set transaction name 'cat_item_count_updated';

delete from cf_geog_cat_item_counts;

insert into cf_geog_cat_item_counts (target_table, coll_obj_count, continent_ocean, ocean_region, country, island_group, island)
    select 'FLAT' as target_table, count(flat.collection_object_id) as coll_obj_count, geog_auth_rec.continent_ocean,
        geog_auth_rec.ocean_region, geog_auth_rec.country, geog_auth_rec.island_group, geog_auth_rec.island
    from geog_auth_rec
        join flat on geog_auth_rec.geog_auth_rec_id = flat.geog_auth_rec_id
    group by geog_auth_rec.continent_ocean, 0, 'FLAT', geog_auth_rec.ocean_region, geog_auth_rec.country,
        geog_auth_rec.island_group, geog_auth_rec.island
    union
    select 'FILTERED_FLAT' as target_table, count(filtered_flat.collection_object_id) as coll_obj_count, geog_auth_rec.continent_ocean,
        geog_auth_rec.ocean_region, geog_auth_rec.country, geog_auth_rec.island_group, geog_auth_rec.island
    from geog_auth_rec
        join filtered_flat on geog_auth_rec.geog_auth_rec_id = filtered_flat.geog_auth_rec_id
    group by geog_auth_rec.continent_ocean, 0, 'FILTERED_FLAT', geog_auth_rec.ocean_region, geog_auth_rec.country,
        geog_auth_rec.island_group, geog_auth_rec.island;

EXCEPTION
    WHEN OTHERS THEN
        rollback;
        DBMS_OUTPUT.PUT_LINE('Error, cf_geog_cat_item_counts not updated');
    RAISE;    

COMMIT;

end;