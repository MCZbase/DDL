
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_COORDINATES" 
( locality_id IN VARCHAR2, part in VARCHAR2 default 'both'
) RETURN VARCHAR2 
-- Given a locality_id, returns a text representation of the accepted latitude-- 
-- and longitude of that locality, selecting the format appropriate for the   --
-- original_lat_long_units, using html entities for the degree, min, sec      --
-- characters.                                                                --
-- Replaces missing minutes or seconds with _  
-- @param locality_id the locality for which to return the accepted lat_long string
-- @param part the part of the latitude and longitude to return, both for lat/long, 
--    lat or latitude for just latitude, long or longitude for just longitude,
-- @return a varchar containing the specified coordinate information as text.
AS
    type rc is ref cursor;
    l_cur rc;
    l_str VARCHAR2(4000);
    l_units VARCHAR2(4000);
    dec_lat VARCHAR2(50);
    dec_long VARCHAR2(50); 
    lat_deg VARCHAR2(50);
    lat_min VARCHAR2(50);
    lat_sec VARCHAR2(50);
    lat_dir VARCHAR2(50);
    long_deg VARCHAR2(50);
    long_min VARCHAR2(50);
    long_sec VARCHAR2(50);
    long_dir VARCHAR2(50);
    dec_lat_min VARCHAR2(50);
    dec_long_min VARCHAR2(50); 
    
BEGIN
   open l_cur for 'select orig_lat_long_units, 
   dec_lat, dec_long, 
   lat_deg, lat_min, lat_sec, lat_dir, 
   long_deg, long_min, long_sec, long_dir, 
   dec_lat_min, dec_long_min 
   from accepted_lat_long where locality_id = :x'
   using locality_id;
   l_str := '';
   loop  
      if part = 'lat' or part = 'latitude' then 
          fetch l_cur into l_units, dec_lat, dec_long, lat_deg, lat_min, lat_sec, lat_dir, long_deg, long_min, long_sec, long_dir, dec_lat_min, dec_long_min;
          exit when l_cur%notfound;
          if l_units = 'decimal degrees' then 
             l_str := dec_lat || '&#176;';
          end if;
          if l_units = 'deg. min. sec.' then
             lat_min := nvl(lat_min,'_');
             lat_sec := nvl(lat_sec,'_');
             l_str := lat_deg || '&#176; ' || lat_min || '&apos; ' || lat_sec || '&apos;&apos; ' || lat_dir;
          end if;
          if l_units = 'degrees dec. minutes' then 
             dec_lat_min := nvl(dec_lat_min, '_');
             l_str := lat_deg || '&#176; ' || dec_lat_min || '&apos; ' || lat_dir;
          end if;
      elsif part = 'long' or part = 'longitude' then
          fetch l_cur into l_units, dec_lat, dec_long, lat_deg, lat_min, lat_sec, lat_dir, long_deg, long_min, long_sec, long_dir, dec_lat_min, dec_long_min;
          exit when l_cur%notfound;
          if l_units = 'decimal degrees' then 
             l_str := dec_long || '&#176;';
          end if;
          if l_units = 'deg. min. sec.' then
             long_min := nvl(long_min,'_');
             long_sec := nvl(long_sec,'_');
             l_str :=  long_deg || '&#176; ' || long_min || '&apos; ' || long_sec || '&apos;&apos; ' || long_dir;
          end if;
          if l_units = 'degrees dec. minutes' then 
             dec_long_min := nvl(dec_long_min,'_');
             l_str := long_deg || '&#176; ' || dec_long_min || '&apos; ' || long_dir;
          end if;
      else 
          fetch l_cur into l_units, dec_lat, dec_long, lat_deg, lat_min, lat_sec, lat_dir, long_deg, long_min, long_sec, long_dir, dec_lat_min, dec_long_min;
          exit when l_cur%notfound;
          if l_units = 'decimal degrees' then 
             l_str := dec_lat || '&#176; / ' || dec_long || '&#176;';
          end if;
          if l_units = 'deg. min. sec.' then
             lat_min := nvl(lat_min,'_');
             lat_sec := nvl(lat_sec,'_');
             long_min := nvl(long_min,'_');
             long_sec := nvl(long_sec,'_');
             l_str := lat_deg || '&#176; ' || lat_min || '&apos; ' || lat_sec || '&apos;&apos; ' || lat_dir || ' / ' || long_deg || '&#176; ' || long_min || '&apos; ' || long_sec || '&apos;&apos; ' || long_dir;
          end if;
          if l_units = 'degrees dec. minutes' then 
             dec_lat_min := nvl(dec_lat_min, '_');
             dec_long_min := nvl(dec_long_min,'_');
             l_str := lat_deg || '&#176; ' || dec_lat_min || '&apos; ' || lat_dir || ' / ' || long_deg || '&#176; ' || dec_long_min || '&apos; ' || long_dir;
          end if;
      end if;
   end loop;
   close l_cur;
   
  RETURN l_str;
END ;