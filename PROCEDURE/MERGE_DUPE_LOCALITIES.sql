
  CREATE OR REPLACE EDITIONABLE PROCEDURE "MERGE_DUPE_LOCALITIES" 
as

cursor c1 is
select min(locality_id) as locality_id, GEOG_AUTH_REC_ID,MAXIMUM_ELEVATION,MINIMUM_ELEVATION,ORIG_ELEV_UNITS,TOWNSHIP,TOWNSHIP_DIRECTION,RANGE,RANGE_DIRECTION,SECTION,SECTION_PART,SPEC_LOCALITY,LOCALITY_REMARKS,LEGACY_SPEC_LOCALITY_FG,DEPTH_UNITS,MIN_DEPTH,MAX_DEPTH,NOGEOREFBECAUSE
from locality
where locality_id not in 
(select locality_id from lat_long)
and locality_id not in
(select locality_id from GEOLOGY_ATTRIBUTES)
group by GEOG_AUTH_REC_ID,MAXIMUM_ELEVATION,MINIMUM_ELEVATION,ORIG_ELEV_UNITS,TOWNSHIP,TOWNSHIP_DIRECTION,RANGE,RANGE_DIRECTION,SECTION,SECTION_PART,SPEC_LOCALITY,LOCALITY_REMARKS,LEGACY_SPEC_LOCALITY_FG,DEPTH_UNITS,MIN_DEPTH,MAX_DEPTH,NOGEOREFBECAUSE
having count(*) > 1
order by count(*) desc;

numLOCALITYID locality.locality_id%TYPE;
numCOUNT number;
numLOGRECS number;

BEGIN
for c1_rec in c1 LOOP

numLOCALITYID := c1_rec.locality_id;
numCOUNT := 0;

execute immediate 'alter trigger TR_COLLEVENT_AU_FLAT disable';
update collecting_event set locality_id = numLOCALITYID where locality_id <> numLOCALITYID and locality_id in
(select locality_id from locality where
nvl(GEOG_AUTH_REC_ID, -1) = nvl(c1_rec.GEOG_AUTH_REC_ID, -1) and
nvl(MAXIMUM_ELEVATION, -1) = nvl(c1_rec.MAXIMUM_ELEVATION,-1) and
nvl(MINIMUM_ELEVATION, -1) = nvl(c1_rec.MINIMUM_ELEVATION, -1) and
nvl(ORIG_ELEV_UNITS, '!XXX!') = nvl(c1_rec.ORIG_ELEV_UNITS, '!XXX!') and
nvl(TOWNSHIP, -1) = nvl(c1_rec.TOWNSHIP, -1) and
nvl(TOWNSHIP_DIRECTION, '!XXX!') = nvl(c1_rec.TOWNSHIP_DIRECTION, '!XXX!') and
nvl(RANGE, -1) = nvl(c1_rec.RANGE, -1) and
nvl(RANGE_DIRECTION, '!XXX!') = nvl(c1_rec.RANGE_DIRECTION, '!XXX!') and
nvl(SECTION, -1) = nvl(c1_rec.SECTION, -1) and
nvl(SECTION_PART, '!XXX!') = nvl(c1_rec.SECTION_PART, '!XXX!') and
nvl(SPEC_LOCALITY, '!XXX!') = nvl(c1_rec.SPEC_LOCALITY, '!XXX!') and
nvl(LOCALITY_REMARKS, '!XXX!') = nvl(c1_rec.LOCALITY_REMARKS, '!XXX!') and
nvl(DEPTH_UNITS, '!XXX!') = nvl(c1_rec.DEPTH_UNITS, '!XXX!') and
nvl(MIN_DEPTH, -1) = nvl(c1_rec.MIN_DEPTH, -1) and
nvl(MAX_DEPTH, -1) = nvl(c1_rec.MAX_DEPTH, -1) and
nvl(NOGEOREFBECAUSE, '!XXX!') = nvl(c1_rec.NOGEOREFBECAUSE, '!XXX!')
and locality_id not in 
(select locality_id from lat_long)
and locality_id not in
(select locality_id from GEOLOGY_ATTRIBUTES));

COMMIT;
execute immediate 'alter trigger TR_COLLEVENT_AU_FLAT enable';
END LOOP;
END;