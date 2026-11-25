
  CREATE OR REPLACE EDITIONABLE TRIGGER "MOVE_CONTAINER" 
before UPDATE or INSERT ON "MCZBASE"."CONTAINER"
--------------------------------------------------------------------------------------------------
-- this trigger checks that container movements are valid. The following rules are enforced:
-- 1) a container may not be moved to itself
-- 2) positions must be locked [currently disabled and not enforced]
	-- note: needs rewitten in forms so positions are simply defined as locked;
	-- then, we can get rid of the locked_position column in the table
--  Rewritten so that positions in freezer boxes are locked, but positions in other containers may
--  be locked or unlocked
--     
-- 3) collections objects cannot be parent containers
-- 4) institutions must be root containers
-- 5) labels (=upper(container_type) like '%LABEL%') cannot be parent or child containers 
--    supports unused functionality to create unplaced cryovial labels then change 
--    them to cryovials when place.
-- 6) child  width,height,length must all be less than or equal to parent  width,height,length, respectively
-- 7) locked containers (positions - see above comment) may not be moved to a new parent
-- 8) a move cannot create a cycle in the container hierarchy
-- 9) containers can only be placed into parents with the same institutional acronym.
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
pi varchar2(20);
cycle_ct number := 0;
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

-- 2 Enforce: positions under freezer boxes are always locked.
IF :NEW.parent_container_id IS NOT NULL THEN
  DECLARE
    v_parent_type container.container_type%TYPE;
  BEGIN
    SELECT container_type
      INTO v_parent_type
      FROM container
     WHERE container_id = :NEW.parent_container_id;

    IF v_parent_type = 'freezer box'
       AND :NEW.container_type = 'position' THEN
      :NEW.locked_position := 1;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- parent row not visible yet (e.g. bulk insert in same txn) – do nothing
      NULL;
  END;
END IF;

-- 4 Enforce: institution containers must remain root (parent_container_id = 0)
IF :NEW.container_type = 'institution' THEN
  -- Normalize NULL to 0 for comparison
  IF NVL(:NEW.parent_container_id, 0) != 0 THEN
    raise_application_error(
      -20000,
      'Institution containers must be root nodes (PARENT_CONTAINER_ID = 0).'
    );
  END IF;

  IF UPDATING THEN
    -- Explicitly disallow any change away from root, for clarity
    IF NVL(:OLD.parent_container_id, 0) != NVL(:NEW.parent_container_id, 0) THEN
      raise_application_error(
        -20000,
        'You cannot change the parent of an institution container; it must remain at the root (PARENT_CONTAINER_ID = 0).'
      );
    END IF;
  END IF;
END IF;

if :new.parent_container_id != :old.parent_container_id then
    -- *** container moved - evaluate changes ***
    -- get data into local vars
    SELECT container_type, width,height,length,locked_position 
      INTO ct,cw,ch,cd,cl
    FROM container WHERE container_id=:new.container_id;

    SELECT container_type,width,height,length, institution_acronym 
       INTO pt,pw,ph,pd,pi
    FROM container WHERE container_id=:new.parent_container_id;

    -- 8 prevent cyclical parentage:
    -- if the proposed new parent is already in the descendant subtree of the child,
    -- then moving child under that parent would create a cycle.
    select count(*) into cycle_ct
    from (
      select c.container_id
      from container c
      start with c.parent_container_id = :new.container_id
      connect by prior c.container_id = c.parent_container_id
     )
     where container_id = :new.parent_container_id;
     
     if cycle_ct > 0 then
       raise_application_error(
         -20000,
         'This move would create a cycle in the container hierarchy.'
       );
    end if;
    
    -- prevent cross‑institution placements
    IF :NEW.institution_acronym IS NOT NULL
       AND pi IS NOT NULL
       AND :NEW.institution_acronym <> pi THEN
      raise_application_error(
        -20000,
        'You cannot place a container into a parent with a different INSTITUTION_ACRONYM. [' || :NEW.institution_acronym || '] into [' || pi ||']'  
      );
    END IF;

    -- see if they've done anything that is not allowed
    -- 3 collection object containers must be leaves.
    if pt = 'collection object' then
       raise_application_error(
           -20000,
           'You cannot put anything in a collection object!'
       );
    end if;
    
    -- 5 containers cannot be put into labels, and labels cannot be put into anything, they must be self standing one node trees.
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
         
     -- 6 children must fit into parents
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
     
     --  7 locked containers cannot be moved
     if cl = 1 then
        raise_application_error(
           -20000,
           'The position you are trying to move is locked.'
        );
     end if;
     
end if;    -- end container moved checks

EXCEPTION
WHEN NO_DATA_FOUND THEN
   -- ColdFusion hasn't commited yet - ignore and move right along....
   NULL;
END move_container;
ALTER TRIGGER "MOVE_CONTAINER" ENABLE