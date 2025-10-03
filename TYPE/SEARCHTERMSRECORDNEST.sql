
  CREATE OR REPLACE EDITIONABLE TYPE "SEARCHTERMSRECORDNEST" AS OBJECT (openparens number, closeparens number, joinfield varchar2(20), searchfield varchar2(50), comparator varchar2(50), searchterm CLOB);
