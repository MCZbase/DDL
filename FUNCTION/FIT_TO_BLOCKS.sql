
  CREATE OR REPLACE FUNCTION "FIT_TO_BLOCKS" 
--  Given some string, picks a set of characters of length blocklength from that 
--  string, starting at the blocknumber multiple of blocklength character.
--  Functions to fit some concatenated set of fields onto a series of small 
--  labels.
(
  FULLSTRING IN VARCHAR2  --  The string to split into blocks
, BLOCKLENGTH IN NUMBER  --  The length of a block
, BLOCKNUMBER IN NUMBER  --  Which block number to select from fullstring
) RETURN VARCHAR2 AS 
  bl  varchar2(4000);
  nextblock varchar2(4000);
  startat number;
  endat number;
BEGIN
  startat := 1+(BLOCKLENGTH*(BLOCKNUMBER-1));
  endat := startat + BLOCKLENGTH-1;
  bl :=  
     trim(
     replace (
       replace(
         replace(
            substr(FULLSTRING,startat,endat),
            chr(13), ' '
         ), chr(10), ' '
      ),'  ',' ')
      );
      -- if block is empty, or next block is empty, don't append ...
      if length(bl)>0 then 
        nextblock := mczbase.fit_to_blocks(FULLSTRING,BLOCKLENGTH,BLOCKNUMBER+1);
        if length(nextblock)>0 then 
           if length(nextblock)>3 then 
              if length(trim(regexp_substr(bl,'[A-Za-z]$')))>0 and length(trim(regexp_substr(nextblock,'^[A-Za-z]')))>0 then
                 -- if within a word, append a dash
                 bl := bl || '- ...';
              else 
                 bl := bl || ' ...';
              end if;
           else
              -- append end of nextblock instead.
              bl := bl || nextblock;
           end if;
        end if;
      end if;
  return bl;
END FIT_TO_BLOCKS;