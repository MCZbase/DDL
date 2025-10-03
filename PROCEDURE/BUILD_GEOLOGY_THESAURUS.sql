
  CREATE OR REPLACE EDITIONABLE PROCEDURE "BUILD_GEOLOGY_THESAURUS" 
--  create or replace a thesaurus named geology_thesaurus containing
--  a thesaurus built from hierarchically nested rows in geology_attribute_hierarchy
AS 
    type rc is ref cursor;
    retval clob;
    level number;
    rowval varchar2(255);
    parval varchar2(255);
    parentid number;
    l_cur    rc;
    l_cur2    rc;
BEGIN
   begin
       ctx_thes.drop_thesaurus('geology_thesaurus');
   exception
       when OTHERS then null;
   end;
   ctx_thes.create_thesaurus('geology_thesaurus',false);
   open l_cur for '
       SELECT
            attribute_value as thesaurus_value,
            parent_id,
            level
        FROM
            geology_attribute_hierarchy
            LEFT JOIN ctgeology_attribute on attribute = geology_attribute
        where (parent_id is not null or  geology_attribute_hierarchy_id in (select parent_id from geology_attribute_hierarchy))    
        START WITH parent_id is null
        CONNECT BY PRIOR geology_attribute_hierarchy_id = parent_id
        ORDER SIBLINGS BY ordinal, attribute_value
    ';
    loop
        fetch l_cur into rowval, parentid, level;
        exit when l_cur%notfound;  
        if level = 1 then 
            CTX_THES.create_phrase('geology_thesaurus',rowval);
        else 
           open l_cur2 for '
            SELECT
               attribute_value 
            FROM geology_attribute_hierarchy
            WHERE geology_attribute_hierarchy_id = :x
            ' using parentid;
           loop
              fetch l_cur2 into parval;
              exit when l_cur2%notfound;  
              CTX_THES.create_relation('geology_thesaurus',parval,'NT',rowval);
            end loop;
        end if;
    end loop;    
END BUILD_GEOLOGY_THESAURUS;

