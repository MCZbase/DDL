
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_COLLCODES_FOR_HIGHERGEOG" ( geog_auth_rec_id in NUMBER )
return VARCHAR
-- Function to obtain list of collection codes and cataloged item counts for a geog_auth_rec.
-- @param geog_auth_rec_id the geog_auth_rec_id of the geog_auth_rec to lookup
-- @return a string list of collection codes and cataloged item counts of material
--    from the specified higher geography.
as 
   type rc is ref cursor;
   retval varchar(2000);
   ccode varchar(50);
   cnt varchar(50);
   sep varchar(2);
   cur rc;
begin
   retval := '';
   sep := '';
   open cur for '
      select to_char(count(co.COLLECTION_OBJECT_ID)), nvl(co.COLLECTION_CDE,''[None]'') from geog_auth_rec
         left join locality l on geog_auth_rec.geog_auth_rec_id = l.geog_auth_rec_id
         left join collecting_event ce on l.locality_id = ce.locality_id
         left join cataloged_item co on ce.collecting_event_id = co.COLLECTING_EVENT_ID
      where geog_auth_rec.geog_auth_rec_id = :x
      group by co.collection_cde
   ' using geog_auth_rec_id;
   loop
      fetch cur into cnt, ccode;
      exit when cur%notfound;
      retval := retval || sep || ccode || '(' || cnt || ')';
      sep := ', ';
   end loop;   
   close cur;   
   return retval;
end;