
  CREATE TABLE "CTCONTAINER_TYPE" 
   (	"CONTAINER_TYPE" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"ROLE" VARCHAR2(50), 
	"EXPECTS_LEAF_CHILD_COUNT" NUMBER, 
	"EXPECTED_PARENT_TYPES" VARCHAR2(4000) DEFAULT 'any' NOT NULL ENABLE, 
	"FORCE_EXPECTED_PARENT_TYPE" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"RANK_ORDER" NUMBER, 
	"DESCRIPTION" VARCHAR2(4000), 
	"VARIABLE_RANK" NUMBER DEFAULT 0 NOT NULL ENABLE
   ) 
  CREATE UNIQUE INDEX "PKEY_CTCONTAINER_TYPE" ON "CTCONTAINER_TYPE" ("CONTAINER_TYPE") 
  
ALTER TABLE "CTCONTAINER_TYPE" ADD CONSTRAINT "PKEY_CTCONTAINER_TYPE" PRIMARY KEY ("CONTAINER_TYPE")
  USING INDEX "PKEY_CTCONTAINER_TYPE"  ENABLE;
COMMENT ON TABLE "CTCONTAINER_TYPE" IS 'Controlled vocabulary for types of containers, along with rules for nesting of containers.';
COMMENT ON COLUMN "CTCONTAINER_TYPE"."ROLE" IS 'Functional role for the container';
COMMENT ON COLUMN "CTCONTAINER_TYPE"."EXPECTS_LEAF_CHILD_COUNT" IS 'Flag indicating whether this container expects to contain leaf children, 0 no, 1 yes one, 2 one or more.';
COMMENT ON COLUMN "CTCONTAINER_TYPE"."EXPECTED_PARENT_TYPES" IS 'Comma separated list of container types that are expected to be direct parents for a node of this type.   May include the special values any (default) or none, where none is expected to be a root of a tree.';
COMMENT ON COLUMN "CTCONTAINER_TYPE"."FORCE_EXPECTED_PARENT_TYPE" IS 'If 1, the expected parent type list is enforced, if 0 a departure from the expected parent type results in a warning.';
COMMENT ON COLUMN "CTCONTAINER_TYPE"."RANK_ORDER" IS 'Rank of nesting depth, 1 is expected to be the root of a tree, higher numbers are deeper nesting depths, generally a container is expected to be placed into a parent container with a lower value rank_order.';
COMMENT ON COLUMN "CTCONTAINER_TYPE"."DESCRIPTION" IS 'Free text description of what sort of things should be classified with this container type.';
COMMENT ON COLUMN "CTCONTAINER_TYPE"."VARIABLE_RANK" IS 'Expected to be used a multiple different ranks, e.g. position, which could refer to position in grouping, position in fixture, position in freezer box, position on slide, etc.  If zero, not expected to vary, if 1 expected to vary.
';
COMMENT ON COLUMN "CTCONTAINER_TYPE"."CONTAINER_TYPE" IS 'Controlled vocabulary for container types.';
