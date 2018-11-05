
  CREATE OR REPLACE FUNCTION "GETPREFERREDAGENTNAME" (aid IN varchar)
RETURN varchar
AS
   n varchar(255);
BEGIN
    SELECT  /*+ RESULT_CACHE */ agent_name INTO n FROM PREFERRED_AGENT_NAME WHERE agent_id=aid;
    RETURN n;
end;
    