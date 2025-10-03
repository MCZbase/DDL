
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MEDIA_SPECPARTATTRIBUTES" 
(
   MEDIA_ID IN NUMBER
)  RETURN VARCHAR 
--  Supporting media metadata delivery  --
--  Given a media id, return a specimen part attributes for that media as json.  --
AS 
  type rc is ref cursor;
  att_type    varchar(2000);
  att_val    varchar(2000);
  retval    varchar(2000);
  separator varchar(2);
  l_cur    rc;
BEGIN
      retval := '{'; 
      separator := '';
      open l_cur for 'select distinct 
          attribute_type, attribute_value 
       from media_relations
          join specimen_part_attribute on media_relations.related_primary_key = specimen_part_attribute.collection_object_id
       where 
          media_relations.media_id = :x 
          and media_relations.media_relationship = ''shows specimen_part''
       union 
       select distinct 
         ''preserve_method'' as attribute_type, 
         preserve_method as attribute_value
       from media_relations
          join specimen_part on media_relations.related_primary_key = specimen_part.collection_object_id
       where 
          media_relations.media_id = :y
          and media_relations.media_relationship = ''shows specimen_part''
       union 
       select distinct 
         ''part_name'' as attribute_type, 
         part_name as attribute_value
       from media_relations
          join specimen_part on media_relations.related_primary_key = specimen_part.collection_object_id
       where 
          media_relations.media_id = :z
          and media_relations.media_relationship = ''shows specimen_part''
      '
      using media_id, media_id, media_id;
      loop
           fetch l_cur into att_type, att_val;
           exit when l_cur%notfound; 
           retval :=  retval || separator || '"' || att_type || '":"' || att_val || '"';
           separator := ',';
      end loop;
      close l_cur;

      retval := retval || '}';

      if retval = '{}' then 
         retval := '';
      end if;

      return retval;
END GET_MEDIA_SPECPARTATTRIBUTES;