
  CREATE OR REPLACE TRIGGER "TR_CATITEM_AI_FLAT" 
AFTER INSERT ON cataloged_item
FOR EACH ROW
BEGIN
INSERT INTO flat (
collection_object_id,
cat_num,
accn_id,
collecting_event_id,
collection_cde,
collection_id,
catalognumbertext,
cat_num_prefix,
cat_num_integer,
cat_num_suffix,
stale_flag)
VALUES (
:NEW.collection_object_id,
:NEW.cat_num,
:NEW.accn_id,
:NEW.collecting_event_id,
:NEW.collection_cde,
:NEW.collection_id,
to_char(:NEW.cat_num),
:NEW.cat_num_prefix,
:NEW.cat_num_integer,
:NEW.cat_num_suffix,
1);
END;

ALTER TRIGGER "TR_CATITEM_AI_FLAT" ENABLE