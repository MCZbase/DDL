
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_CLOSEDLOANS_CATITEM" 
-- Given a collection_object_id for a cataloged item  
-- returns a comma delimited, concatenated list of the  
-- loan numbers of open loans parts of that item are in closed loans   
-- If there are no closed loans, then an empty string is returned.       
-- @param cataloged_item_coll_obj_id the collection object for which 
--   to show closed loans
-- @param show_parts if 1, then list which parts are in the loans.
-- @return a list of loan numbers of open loans for parts of the 
--   cataloged item, optionaly including the parts.
-- @see get_openloans_catitem
( cataloged_item_coll_obj_id IN VARCHAR2, show_parts INT DEFAULT 0 )
RETURN VARCHAR2 AS
  type rc is ref cursor;
  l_str    varchar2(4000);
  l_sep    varchar2(3);
  part_name    varchar2(4000);
  preserve_method    varchar2(4000);
  loan_number    varchar2(4000);
  consumable    varchar2(4000);
  l_cur    rc;
begin
  l_sep := '';
  open l_cur for '
    select part_name, preserve_method, loan_number, 
      decode(loan_type, ''consumable'', ''consumable'', '''') consumable  
    from specimen_part 
    left join loan_item on specimen_part.collection_object_id = loan_item.collection_object_id
    left join loan on loan_item.transaction_id = loan.transaction_id
    where derived_from_cat_item = :x
    and loan_status = ''closed''
   ' using cataloged_item_coll_obj_id;  
  loop
     fetch l_cur into part_name, preserve_method, loan_number, consumable;
     exit when l_cur%notfound;
     if (consumable is not null) then 
        loan_number := consumable || ' ' || loan_number;
     end if;
     if show_parts=1 then
         l_str := l_str || l_sep || loan_number || ' (' || part_name || ':' || preserve_method || ')';
     else 
         l_str := l_str || l_sep || loan_number;
     end if;
     l_sep := ', ';
end loop;
close l_cur;
       return l_str;
END;