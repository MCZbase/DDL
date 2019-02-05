
  CREATE OR REPLACE FUNCTION "GET_COLLCODES_FOR_LOCALITY" ( locality_id in NUMBER )
return VARCHAR
-- Function to obtain list of collection codes and cataloged item counts for a locality.
-- @param locality_id the locality_id of the locality to lookup
-- @return a string list of collection codes and cataloged item counts of material
--    from the specified locality.
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
      select to_char(count(co.COLLECTION_OBJECT_ID)), nvl(co.COLLECTION_CDE,''[None]'') from locality l
         left join collecting_event ce on l.locality_id = ce.locality_id
         left join cataloged_item co on ce.collecting_event_id = co.COLLECTING_EVENT_ID
      where l.locality_id = :x
      group by co.collection_cde
   ' using locality_id;
   loop
      fetch cur into cnt, ccode;
      exit when cur%notfound;
      retval := retval || sep || ccode || '(' || cnt || ')';
      sep := ', ';
   end loop;   
   close cur;   
   return retval;
end;