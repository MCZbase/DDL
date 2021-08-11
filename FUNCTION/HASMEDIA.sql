
  CREATE OR REPLACE FUNCTION "HASMEDIA" (p_key_val  in number )
-- Given a collection_object_id used as a related primary key in media_relations
-- return the number of instances where that value is in the media relationship
-- 'shows cataloged_item', could be used to count number of media records for
-- a cataloged item.
-- ?? unused ??
-- @param p_key_val the related_primary_key value to check for shows cataloged_item
-- @return 0 or the count of the number of records in the media relationship
-- shows cataloged_item with the provided related primary key.
return number
as
l_yn number;

begin
select count(*) into l_yn from media_relations where media_relationship='shows cataloged_item' and related_primary_key = p_key_val;
return l_yn;
end;