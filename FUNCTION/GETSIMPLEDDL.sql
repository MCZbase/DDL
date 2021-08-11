
  CREATE OR REPLACE FUNCTION "GETSIMPLEDDL" (objecttype in varchar2, objectname in varchar2)
-- obtain a simple view of the create object DDL for an object (simple, that is, without storage
-- or segment attributes for a table).
-- @param objecttype the type of object represented by objectname (e.g. TABLE, VIEW, FUNCTION)
-- @param objectname the object for which to return the DDL.
-- @return a clob containing the ddl for the specified object.
    return clob is
   -- Define local variables.
   h   number; --handle returned by OPEN
   th  number; -- handle returned by ADD_TRANSFORM
   doc clob;
begin
   -- Specify the object type.
    if objecttype = 'JOB' then 
        doc := dbms_metadata.get_ddl('PROCOBJ',objectname);
    else
       h := dbms_metadata.open(objecttype);
       -- Use filters to specify the particular object desired.
       dbms_metadata.set_filter(h
                               ,'SCHEMA'
                               ,'MCZBASE');
       dbms_metadata.set_filter(h
                               ,'NAME'
                               ,objectname);
       -- Request that the schema name be modified.
       th := dbms_metadata.add_transform(h
                                        ,'MODIFY');
       dbms_metadata.set_remap_param(th
                                    ,'REMAP_SCHEMA'
                                    ,'MCZBASE'
                                    ,null);
       -- Request that the metadata be transformed into creation DDL.
       th := dbms_metadata.add_transform(h
                                        ,'DDL');
       -- Specify that segment attributes are not to be returned.
       if objecttype in ('TABLE', 'INDEX') then
               dbms_metadata.set_transform_param(th
                                        ,'SEGMENT_ATTRIBUTES'
                                        ,false);
               dbms_metadata.set_transform_param(th
                                        ,'STORAGE'
                                        ,false);
       end if;
       -- Fetch the object.
       doc := dbms_metadata.fetch_clob(h);
       -- Release resources.
       dbms_metadata.close(h);
    end if;
   return doc;
end getsimpleddl;