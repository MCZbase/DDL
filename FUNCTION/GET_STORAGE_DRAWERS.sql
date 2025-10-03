
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_STORAGE_DRAWERS" (collection_object_id IN number )
return varchar2
-- given an collection object id for a cataloged item, return the drawer level containers (compartment, freezer rack) 
-- in which parts for that cataloged item are stored.
-- @param collobjid the collection object id of a cataloged item.
-- @return varchar containing a semicolon separated list of distinct compartments etc in which parts for the specfied cataloged item are stored.
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
     select distinct drawer from (
     select 
        decode(mczbase.get_storage_parentatrank(mczbase.get_current_container_id(collection_object_id), ''compartment'',0),''Unplaced'','' '',mczbase.get_storage_parentatrank(mczbase.get_current_container_id(collection_object_id), ''compartment'',0))
        ||
        decode(mczbase.get_storage_parentatrank(mczbase.get_current_container_id(collection_object_id), ''freezer rack'',0),''Unplaced'','' '',mczbase.get_storage_parentatrank(mczbase.get_current_container_id(collection_object_id), ''freezer rack'',0))
        as drawer
     from specimen_part
     where derived_from_cat_item = :x
     ) order by drawer
     '
  using collection_object_id;

  loop
    fetch l_cur into val;
    exit when l_cur%notfound;
    if trim(val) IS NULL then
       retval := retval || separator || 'Unplaced';
    else   
       retval := retval || separator || trim(val);
    end if;
    separator := '; ';
  end loop;
  close l_cur;

  return retval;
END GET_STORAGE_DRAWERS;

