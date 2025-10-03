
  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_MAMMAL_MEASUREMENTS" 
( p_key_val IN NUMBER
) 
-- Given a collection_object.collection_object_id, returns the measurement --
-- attributes of that collection object in standardized Mammalogy format   --
-- e.g. 133-49-20-16=15g                                                   --
-- Standard order is Tot-Tail-HF-Ear=WT with units for WT, all others are  --
-- expected to be in milimeters.                                           --
-- Special case of Chiroptera (adds FA and TRA)                            --
-- Tot-Tail-HF-Ear=WT FA=[forearm][units], TRA=[tragus][units]             --
-- Example: 63-20-8-14=3.5g FA=26mm, TRA=14mm                              --
-- Replace missing values with x, example 63-x-8-14=6g                     --
RETURN VARCHAR2 
AS
   type rc is ref cursor;
   l_str varchar2(50);
   l_ord INTEGER;
   l_typ VARCHAR2(4);
   l_attribute varchar2(400);
   l_suffix varchar2(60);
   l_cur rc;
   last_ord INTEGER;
BEGIN
  open l_cur for '
select 1 ordinal, ''Tot'' typ, attribute_value, ''-'' suffix from attributes
where attribute_type = ''total length'' and collection_object_id = :x 
UNION 
select 2 ordinal, ''Tail'' typ, attribute_value, ''-'' suffix from attributes
where attribute_type = ''tail length'' and collection_object_id = :x1 
UNION
select 3 ordinal, ''HF'' typ, attribute_value, ''-'' suffix from attributes
where attribute_type = ''hind foot with claw'' and collection_object_id = :x2 
UNION
select 4 ordinal, ''Ear'' typ, attribute_value, ''='' suffix from attributes
where attribute_type = ''ear from notch'' and collection_object_id = :x3 
UNION
select 5 ordinal, ''WT'' typ, attribute_value, attribute_units suffix from
attributes where attribute_type = ''weight'' and collection_object_id = :x4 
UNION 
select 6 ordinal, ''FA'' typ, attribute_value, attribute_units suffix from
attributes where attribute_type = ''forearm length'' and collection_object_id =
:x5
UNION 
select 7 ordinal, ''TRA'' typ, attribute_value, attribute_units suffix from
attributes where attribute_type = ''tragus length'' and collection_object_id =
:x6
order by ordinal
'
  using p_key_val, p_key_val, p_key_val, p_key_val, p_key_val, p_key_val,
p_key_val;
  last_ord := 0;
  loop
     fetch l_cur into l_ord, l_typ, l_attribute, l_suffix;
     exit when l_cur%notfound;
     if l_ord = last_ord + 2 then 
         if l_ord < 5 then 
         l_str := l_str || 'x-';
         else 
           if l_ord = 5 then 
              l_str := l_str || 'x=';
           end if;
           if l_ord = 6 then 
              l_str := l_str || 'x';
           end if;           
         end if; 
     end if;
     if l_ord = last_ord + 3 then 
         if l_ord < 5 then 
         l_str := l_str || 'x-x-';
         else 
           if l_ord = 5 then 
              l_str := l_str || 'x-x=';
           end if;
           if l_ord = 6 then 
              l_str := l_str || 'x=x';
           end if;           
         end if; 
     end if;
     if l_ord = last_ord + 4 then 
         if l_ord < 5 then 
         l_str := l_str || 'x-x-x-';
         else 
           if l_ord = 5 then 
              l_str := l_str || 'x-x-x=';
           end if;
           if l_ord = 6 then 
              l_str := l_str || 'x-x=x';
           end if;           
         end if; 
     end if;    
     if l_ord = last_ord + 5 then 
           if l_ord = 5 then 
              l_str := l_str || 'x-x-x-x=';
           end if;
           if l_ord = 6 then 
              l_str := l_str || 'x-x-x=x';
           end if;           
     end if;     
     last_ord := l_ord;
     if l_ord < 6 then 
         l_str := l_str || l_attribute || l_suffix;
     else
        if l_ord = 6 and l_attribute is not null then 
           l_str := l_str || ' ' || l_typ || '=' || l_attribute || l_suffix ||
', ';
        end if; 
        if l_ord = 7 and l_attribute is not null then 
           l_str := l_str || l_typ || '=' || l_attribute || l_suffix ;
        end if; 
     end if;
  end loop;
  if last_ord > 0 and last_ord < 5 then 
     last_ord := last_ord + 1;
     FOR Lcntr IN last_ord..5
     LOOP
         if Lcntr < 4 then 
         l_str := l_str || 'x-';
         else 
           if Lcntr = 4 then 
              l_str := l_str || 'x=';
           end if;
           if Lcntr = 5 then 
              l_str := l_str || 'x';
           end if;           
         end if;
     END LOOP;
  end if;
  close l_cur;

  RETURN l_str;
END;
 
 