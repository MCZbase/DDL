
  CREATE OR REPLACE TYPE "SEARCHTERMSRECORD" AS OBJECT (searchfield varchar2(20), comparator varchar2(10), searchterm varchar2(4000))
; 
ALTER TYPE ""."SEARCHTERMSRECORD" modify attribute comparator varchar2(50) cascade
; 
ALTER TYPE ""."SEARCHTERMSRECORD" add attribute (joinfield varchar2(20)) cascade
; 
ALTER TYPE ""."SEARCHTERMSRECORD" modify attribute searchfield varchar2(50 byte) cascade
