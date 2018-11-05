
  CREATE OR REPLACE FUNCTION "HASMEDIA" (p_key_val  in number )
return number
as
l_yn number;

begin
select count(*) into l_yn from media_relations where media_relationship='shows cataloged_item' and related_primary_key = p_key_val;
return l_yn;
end;