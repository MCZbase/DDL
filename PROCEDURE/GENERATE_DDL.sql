
  CREATE OR REPLACE PROCEDURE "GENERATE_DDL" as 

cursor c1 is 
  select object_type, object_name from user_objects where object_type not in ('LOB', 'PACKAGE BODY', 'TABLE PARTITION', 'DATABASE LINK') and object_name not like 'X_%';
  
  objDDL clob;
  ddlFile UTL_FILE.file_type;
  
begin
for c1_rec in c1 loop

select mczbase.getsimpleddl(c1_rec.object_type, c1_rec.object_name) into objDDL from dual;

---using UTL_FILE to write to file
/************
ddlFile := UTL_FILE.fopen (c1_rec.object_type, c1_rec.object_name || '.sql', 'w');
---dbms_output.put_line('exporting ' || c1_rec.object_type || ' ' || c1_rec.object_name || ' to ' || c1_rec.object_name || '.sql')  ;

      UTL_FILE.put (ddlFile, objDDL);
      UTL_FILE.fclose (ddlFile);  
************/

---using CLOB2FILE to write to file 

DBMS_XSLPROCESSOR.clob2file (objDDL,
                                c1_rec.object_type,
                                c1_rec.object_name || '.sql'
                               );


end loop;
end;