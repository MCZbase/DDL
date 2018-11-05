
  CREATE OR REPLACE FUNCTION "GET_PARENTFOR_DATASHOT" 
(
   family IN varchar2,
   collection in varchar2
) 
--  Given a family and a collection, return the container_id of the container to 
--  place the pin container into for material ingested from DataShot, in most cases
--  obtain the room within which the container is stored.
--  This function is intended for use on ingest or for quality control.  
--  Do not use to change the placement of material in MCZbase which has a 
--  current container placement.
RETURN VARCHAR2 AS 
      type rc is ref cursor;
      contid    number;
      room      varchar2(255);  -- room or grouping which contains this material
      retval    number;
      l_cur    rc;
   BEGIN
       room := null;
       retval := 0;
       case collection 
          when 'General Ant Collection' then room := 'MCZ-419';
          when 'Type Collection' then room := 'Ent_Lep-butterfly-types';
          when 'Nabokov collection' then room := 'Ent_Nabokov';
          
          -- none presently in DataShot
          when 'Boston Harbor Islands' then room := 'Ent_BHI';          
          -- 43 presently in data shot, but as collection, not location in collection.
          when 'Harris Collection' then room := 'Ent_Harris';    
          else
             room:=null;
        end case;

        if room is null then 
           case family 
             when 'Lycaenidae' then room := 'MCZ-506';
             when 'Riodinidae' then room := 'MCZ-506';
             when 'Nymphalidae' then room := 'MCZ-506';
             when 'Lycaenidae' then room := 'MCZ-506';
             when 'Pieridae' then room := 'MCZ-506';
             when 'Libytheidae' then room := 'MCZ-506';
             
             when 'Hesperiidae' then room := 'MCZ-502';
             
             when 'Papilionidae' then room := 'MCZ-5';  -- on fifth floor, either 502 or 506, but can't tell.
             else 
                room := null;
           end case;
           
           if room is null and collection = 'General Lepidoptera Collection' then
              room := 'MCZ-5';
           end if;
           
        end if;    


       if room is not null then 
          open l_cur for ' select container_id from container where label = :x  '
          using room;

          loop
              fetch l_cur into contid;
              exit when l_cur%notfound;
              retval := contid;
          end loop;
       
       end if;

       close l_cur;            

       return retval;

END ;