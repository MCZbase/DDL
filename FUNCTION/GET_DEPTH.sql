
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_DEPTH" 
-- Given a locality.locality_id, returns the depth as a varchar --
-- by combining min_depth, max_depth, and depth_units           --
-- ommits the - separator if max_depth is null.                 --
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
       open l_cur for 'select min_depth, max_depth, depth_units from locality where locality_id = :x '
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
 
 