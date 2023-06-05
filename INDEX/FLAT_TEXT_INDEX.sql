
  CREATE INDEX "FLAT_TEXT_INDEX" ON "FLAT" ("CAT_NUM") 
   INDEXTYPE IS "CTXSYS"."CONTEXT"  PARAMETERS ('datastore flat_multi
storage flat_text_store')