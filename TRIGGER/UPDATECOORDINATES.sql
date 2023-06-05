
  CREATE OR REPLACE TRIGGER "UPDATECOORDINATES" 
-- Trigger to calculate decimal degrees from other formats when data are changed.
-- DLM 6Dec04
-- translates degrees with decimal minutes, degrees minutes seconds, and utm to 
-- decimal latitude/longitude.
BEFORE UPDATE OR INSERT ON "MCZBASE"."LAT_LONG"
FOR EACH ROW
declare
  temp_dec_lat NUMBER;
  temp_dec_long NUMBER;
BEGIN
    IF :new.orig_lat_long_units = 'deg. min. sec.' THEN
    	:new.dec_lat := :new.lat_deg + (:new.lat_min / 60) + (nvl(:new.lat_sec,30) / 3600);
    	
        IF :new.lat_dir = 'S' THEN
            :new.dec_lat := :new.dec_lat * -1;
        END IF;
            
        :new.dec_long := :new.long_deg + (:new.long_min / 60) + (nvl(:new.long_sec,30) / 3600);
        
        IF :new.long_dir = 'W' THEN
            :new.dec_long := :new.dec_long * -1;
        END IF;
        
        IF :new.lat_sec is null or :new.long_sec is null then
          :new.MAX_ERROR_DISTANCE := 115;
          :new.MAX_ERROR_UNITS := 'km';
        END IF;
        
    ELSIF :new.orig_lat_long_units = 'degrees dec. minutes' THEN
    	:new.dec_lat := :new.lat_deg + (:new.dec_lat_min / 60);
    	
    	if :new.lat_dir = 'S' THEN
    		:new.dec_lat := :new.dec_lat * -1;
    	end if;
    	    
    	:new.dec_long := :new.long_deg + (:new.dec_long_min / 60);
    	
    	IF :new.long_dir = 'W' THEN
    		:new.dec_long := :new.dec_long * -1;
    	END IF;
    ELSIF :new.orig_lat_long_units = 'UTM' THEN
       -- use UTM Zone and datum to find srid, then transform utm easting and northing for that zone to latitude longitude in WGS 84
       -- map values in code table for datum to strings found in sdo_coord_ref_sys.coord_ref_sys_name
       -- if datum is other than WGS 84, dec_lat/dec_long will be in WGS 84, but datum will be that for the UTM coordinates.
       -- TODO: preserve as a verbatim srs.
       select 
         round(t.sdo.sdo_point.x,5), 
         round(t.sdo.sdo_point.y,5)
       into 
         temp_dec_long,
         temp_dec_lat
       from (
            select sdo_cs.transform(
               sdo_geometry(
                  2001,
                  (select srid from sdo_coord_ref_sys where coord_ref_sys_name like (
                       select ('%' || decode(:new.datum, 'WGS84', 'WGS 84', 'WGS 1984', 'WGS 84', 'North American 1983', 'NAD83',:new.datum) || '% UTM zone ' || REGEXP_REPLACE(REGEXP_REPLACE (:new.utm_zone, '[A-M]', 'S'),'[N-Z]','N') || '%') from dual)
                  ),
                  SDO_POINT_TYPE(:new.utm_ew, :new.utm_ns,null)
                  , null, null
                ), 
                8307) as sdo
             from dual
        ) t;
        :new.dec_lat := temp_dec_lat;
        :new.dec_long := temp_dec_long;          
    END IF;
END updateCoordinates;
ALTER TRIGGER "UPDATECOORDINATES" ENABLE