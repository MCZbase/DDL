
  CREATE OR REPLACE PACKAGE "STATE_PKG" 
   as
   	type ridArray is table of number index by binary_integer;
       newRows ridArray;
       empty   ridArray;
end;
 
 
