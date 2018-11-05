
  CREATE OR REPLACE FUNCTION "GET_ELEVATION" 
-- Given a locality.locality_id, returns the elevation as a varchar --
-- by combining min_elevation, max_elevation, and orig_elevation_units           --
-- ommits the - separator if max_levation is null.                 --
-- examples:  32 m, 32-50 m --
( locality_id IN NUMBER
) RETURN VARCHAR2 
as
      type rc is ref cursor;
      l_str    varchar2(4000);
      l_sep    varchar2(2);
      l_min    varchar2(4000);
      l_max    varchar2(4000);
      l_units  varchar2(4000);
      l_cur    rc;
   begin
       open l_cur for 'select minimum_elevation, maximum_elevation, orig_elev_units from locality where locality_id = :x '
   using locality_id;
       loop
           fetch l_cur into l_min, l_max, l_units;
           exit when l_cur%notfound;
           l_sep := '-';
           if (l_max is null or l_min is null) THEN
              l_sep := '';
           end if;
           l_str := l_min || l_sep || l_max || ' ' || l_units;
       end loop;
       close l_cur;

       return l_str;
END;
 