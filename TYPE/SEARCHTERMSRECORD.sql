
  CREATE OR REPLACE EDITIONABLE TYPE "SEARCHTERMSRECORD" AS OBJECT (joinfield varchar2(20), searchfield varchar2(50), comparator varchar2(50), searchterm CLOB)
