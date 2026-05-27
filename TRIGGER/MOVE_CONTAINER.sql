
  CREATE OR REPLACE EDITIONABLE TRIGGER "MOVE_CONTAINER" 
before UPDATE or INSERT ON "MCZBASE"."CONTAINER"
--------------------------------------------------------------------------------------------------
-- this trigger checks that container movements are valid. The following rules are enforced:
-- 1) a container may not be moved to itself
-- 2) positions must be locked [currently disabled and not enforced]
	-- note: needs rewitten in forms so positions are simply defined as locked;
	-- then, we can get rid of the locked_position column in the table
-- 3) collections objects cannot be parent containers
-- 4) labels (=upper(container_type) like '%LABEL%') cannot be parent or child containers
-- 5) child  width,height,length must all be less than or equal to parent  width,height,length, respectively
-- 6) locked containers (positions - see above comment) may not be moved to a new parent
--  
-- Actions taken to set parent_install_date:
-- - When inserting a new container and no value is provided for parent_install_date
--   (and parent_container_id is not null), set parent_install_date to current timestamp (SYSDATE).
-- - When updating a container and parent_container_id changes (and new parent_container_id is not null),
--   set parent_install_date to current timestamp (SYSDATE).

--------------------------------------------------------------------------------------------------
for each row
declare
ct varchar2(60);
cw number;
ch number;
cd number;
 pt varchar2(60);
 pw number;
 ph number;
 pd number;
 cl number;
pragma autonomous_transaction;
BEGIN

-- set parent_install_date when inserting and none provided, and when parent is not null
IF INSERTING THEN
    IF :NEW.parent_container_id IS NOT NULL AND :NEW.parent_install_date IS NULL THEN
      :NEW.parent_install_date := SYSDATE;
    END IF;
ELSIF UPDATING THEN
    -- only when parent_container_id actually changed and new parent is not null
    IF NVL(:NEW.parent_container_id, -999999999) != NVL(:OLD.parent_container_id, -999999999)
       AND :NEW.parent_container_id IS NOT NULL THEN
      :NEW.parent_install_date := SYSDATE;
    END IF;
END IF;

-- 1 prevent a container from being placed into itself
if :new.container_id = :new.parent_container_id then
	 raise_application_error(
              -20000,
              'You cannot put a container into itself!'
            );
end if;

-- 2 containers of type position must be locked.
--if :new.container_type = 'position' AND :new.LOCKED_POSITION != 1 then
--	raise_application_error(
--              -20000,
--              'Positions must be locked.'
--            );
--end if;

if :new.parent_container_id != :old.parent_container_id then
/* they moved a container - run this trigger */
-- get data into local vars
select
container_type, width,height,length,locked_position into ct,cw,ch,cd,cl
 FROM container WHERE container_id=:new.container_id;
select
container_type,width,height,length into pt,pw,ph,pd
 FROM container WHERE container_id=:new.parent_container_id;
 -- see if they've done anything that is not allowed
        -- 3 collection object containers must be leaves.
         if pt = 'collection object' then
                 raise_application_error(
              -20000,
              'You cannot put anything in a collection object!'
            );
         end if;
        -- 4 containers cannot be put into labels, and labels cannot be put into anything, they must be self standing one node trees.
         if pt LIKE '%label%' then
          raise_application_error(
              -20000,
              'You cannot put anything in a label! (container_id:' || :NEW.container_id || '; parent_container_id: ' || :NEW.parent_container_id
            );
         end if;
          if ct LIKE '%label%' then
          raise_application_error(
              -20000,
              'A label cannot have a parent!'
            );
         end if;
         -- 5 children must fit into parents
         if ch >= ph then
          raise_application_error(
              -20000,
              'The child won''t fit into the parent (check height)!'
            );
         end if;
          if cd >= pd then
          raise_application_error(
              -20000,
              'The child won''t fit into the parent (check length)!'
            );
         end if;
          if cw >= pw then
          raise_application_error(
              -20000,
              'The child won''t fit into the parent (check width)!'
            );
         end if;
         --  6 locked containers cannot be moved
          if cl = 1 then
          raise_application_error(
              -20000,
              'The position you are trying to move is locked.'
            );
         end if;
end if;

EXCEPTION
WHEN NO_DATA_FOUND THEN
   -- ColdFusion hasn't commited yet - ignore and move right along....
   NULL;
END move_container;
--ALTER TRIGGER "MCZBASE"."MOVE_CONTAINER" ENABLE



ALTER TRIGGER "MOVE_CONTAINER" ENABLE