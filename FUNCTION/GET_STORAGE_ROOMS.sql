
  CREATE OR REPLACE FUNCTION "GET_STORAGE_ROOMS" (collection_object_id IN number )
return varchar2
-- given an collection object id for a cataloged item, return the rooms in which parts for that cataloged item are stored.
-- @param collobjid the collection object id of a cataloged item.
-- @return varchar containing a semicolon separated list of distinct rooms in which parts for the specfied cataloged item are stored.
as
  type rc is ref cursor;
  separator varchar2(30);
  val varchar2(255);
  retval varchar2(4000);     
  l_cur    rc;
begin
  retval := '';
  separator := '';
  open l_cur for '
     select distinct mczbase.get_storage_parentatrank(mczbase.get_current_container_id(collection_object_id), ''room'',0) as room
     from specimen_part
     where derived_from_cat_item = :x
     order by mczbase.get_storage_parentatrank(mczbase.get_current_container_id(collection_object_id), ''room'',0)
     '
  using collection_object_id;

  loop
    fetch l_cur into val;
    exit when l_cur%notfound;
    retval := retval || separator || val;
    separator := '; ';
  end loop;
  close l_cur;

  return retval;
END GET_STORAGE_ROOMS;