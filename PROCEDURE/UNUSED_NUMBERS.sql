
  CREATE OR REPLACE PROCEDURE "UNUSED_NUMBERS" (collcde in varchar2, catnumprefix in varchar2) as

---catalog numbers
Cursor c1 is WITH aquery AS 
(SELECT cat_num_integer after_gap, 
    LAG(cat_num_integer,1,0) OVER (ORDER BY cat_num_integer) before_gap 
   FROM cataloged_item 
    where collection_cde = collcde 
      and nvl(cat_num_prefix, 'XXX') = nvl(catnumprefix, 'XXX')
      and cat_num_integer <= 35586 )
SELECT  before_gap, after_gap, after_gap - before_gap as gap_size 
  FROM aquery 
 WHERE before_gap != 0 
   AND after_gap - before_gap > 1 
order by before_gap;

---other id numbers
/*Cursor c1 is WITH aquery AS 
(select other_id_number after_gap,
    LAG(other_id_number,1,0) OVER (ORDER BY other_id_number) before_gap
    from COLL_OBJ_OTHER_ID_NUM where other_id_prefix = catnumprefix and collection_object_id in
    (select collection_object_id from flat where collection_cde = 'Ent' and cat_num_prefix is null and family = 'Formicidae')) 
SELECT  before_gap, after_gap, after_gap - before_gap as gap_size 
  FROM aquery 
 WHERE before_gap != 0 
   AND after_gap - before_gap > 1 
order by before_gap;*/

/*Cursor c1 is with aquery as
(select other_id_number after_gap,
LAG(other_id_number,1,0) OVER (ORDER BY other_id_prefix, other_id_number) before_gap
from coll_obj_other_id_num where  other_id_prefix = 'SPC '  and other_id_number <= 7526 )
select before_gap, after_gap
from aquery
where before_gap !=0
and after_gap-before_gap > 1
order by before_gap;*/

x number;

BEGIN

execute immediate 'truncate table unusednumbers';

for c1_rec in c1 loop
  for x in c1_rec.before_gap+1..c1_rec.after_gap-1 loop
    insert into unusednumbers(cat_num, cat_num_prefix) values(x, catnumprefix);
  end loop;
end loop;

END;