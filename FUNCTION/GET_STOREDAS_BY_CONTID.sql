
  CREATE OR REPLACE FUNCTION "GET_STOREDAS_BY_CONTID" (containerId  in number )
    return varchar2
   as
   	storedAs    varchar2(255);
   begin
   
   select 
    scientific_name 
      into 
    storedAs 
      from 
    COLL_OBJ_CONT_HIST ch, 
     (select sp.collection_object_id, i.scientific_name
     from specimen_part sp, cataloged_item ci, identification i
     where sp.derived_from_cat_item = ci.collection_object_id
     and ci.collection_object_id = i.collection_object_id
     and i.stored_as_fg = 1) sa
   where 
    CH.CONTAINER_ID = containerId
    and ch.collection_object_id = SA.COLLECTION_OBJECT_ID(+)
    and CH.CURRENT_CONTAINER_FG = 1;

   return storedAs;
  end;