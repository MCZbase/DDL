
  CREATE OR REPLACE TRIGGER "UPDATECOORDINATES" 
-- Trigger to calculate decimal degrees from other formats when data are changed.
-- DLM 6Dec04
BEFORE UPDATE OR INSERT ON "LAT_LONG"
FOR EACH ROW
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
    END IF;
END updateCoordinates;
ALTER TRIGGER "UPDATECOORDINATES" ENABLE