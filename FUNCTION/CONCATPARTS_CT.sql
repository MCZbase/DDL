
  CREATE OR REPLACE EDITIONABLE FUNCTION "CONCATPARTS_CT" ( collobjid in integer, truncate_at in integer default 4000)
return varchar2
--  given a collection object id return a semicolon delimited string list 
--  of part names, preserve methods, and a subsample marker for all parts 
--  not discarded, used up, deaccessioned, or missing for that collection object
--  with counts of the number of parts of each distinct combanation of part name, 
--  preserve_method, and subsample marker, if over truncate_at in length, then
--  truncated at that length with the last three characters of the truncated 
--  string replaced with an elipsis.
--  @param colobjid the collection object id of the cataloged item for which
--  to return a part list.
--  @param truncate_at number of characters at which to truncate the parts list, default 4000. 
--  @return a varchar of length up to truncate_at containing the concatenated part list.
as
    t varchar2(255);
    result varchar2(4000);
    sep varchar2(2):='';
    trunc varchar2(3);
begin
    trunc := '...';
    for r in (
        select
            count(*) as ct,
            part_name,
            preserve_method,
            sampled_from_obj_id
        from
            specimen_part,
            ctspecimen_part_list_order,
            coll_object
        where
            specimen_part.collection_object_id=coll_object.collection_object_id and
            specimen_part.part_name =  ctspecimen_part_list_order.partname (+) and 
            coll_obj_disposition not in ('discarded','used up','deaccessioned','missing','transfer of custody') and
            derived_from_cat_item = collobjid
        group by part_name, preserve_method, sampled_from_obj_id, list_order            
        ORDER BY list_order,sampled_from_obj_id DESC, part_name desc, preserve_method
    ) loop
        t:=r.part_name;
        if r.preserve_method is not null then
            t:=t ||' ('|| r.preserve_method ||')';
        end if;
        if r.sampled_from_obj_id is not null then
            t:=t||' sample';
        end if;
        if r.ct > 1 then
            t:=t|| '[' || r.ct || ']';
        end if;
        if (length(result) + length(t) > truncate_at) then
            if (length(result) < (truncate_at-3) and length(trunc) > 0) then 
              result:=result||trunc;
            end if;
            trunc:='';
        else
            result:=result||sep||t;
        end if;
        sep:='; ';
    end loop;
    return result;
end;