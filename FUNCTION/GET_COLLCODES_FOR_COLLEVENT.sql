
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_COLLCODES_FOR_COLLEVENT" ( collecting_event_id in NUMBER )
return VARCHAR
-- Function to obtain list of collection codes and cataloged item counts for a collecting_event.
-- @param collecting_event_id the collecting_event_id of the collecting event to lookup
-- @return a string list of collection codes and cataloged item counts of material
--    from the specified collecting event.
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
      select to_char(count(co.COLLECTION_OBJECT_ID)) cnt, 
             nvl(co.COLLECTION_CDE, ''[None]'' ) ccode
      from collecting_event ce 
         left join cataloged_item co on ce.collecting_event_id = co.COLLECTING_EVENT_ID
      where ce.collecting_event_id = :x
      group by co.collection_cde
   ' using collecting_event_id;
   
   loop
      fetch cur into cnt, ccode;
      exit when cur%notfound;
      retval := retval || sep || ccode || '(' || cnt || ')';
      sep := ', ';
   end loop;   
   close cur;   
   return retval;
end;