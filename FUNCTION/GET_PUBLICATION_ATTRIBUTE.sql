
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_PUBLICATION_ATTRIBUTE" 
(
  PUBLICATION_ID IN NUMBER,
  attribute_type in VARCHAR2
) RETURN VARCHAR2 
--  Supporting the Publications part of the MCZ website  --
--  Given a publication id and an attribute type, return --
--  the attribute value.                                 --
AS 
        type rc is ref cursor;
        l_str    varchar2(4000);
       l_sep    varchar2(30);
       l_val    varchar2(4000);

       l_cur    rc;
   begin

      open l_cur for 'select pub_att_value
                        from publication_attributes
                        where publication_id = :x
                          and publication_attribute = :x '
                   using publication_id, attribute_type;

       loop
           fetch l_cur into l_val;
           exit when l_cur%notfound;
           l_str := l_str || l_sep || l_val;
           l_sep := '; ';
       end loop;
       close l_cur;

       return l_str;
END GET_PUBLICATION_ATTRIBUTE;
 