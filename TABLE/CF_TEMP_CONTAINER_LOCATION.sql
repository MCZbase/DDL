
  CREATE TABLE "CF_TEMP_CONTAINER_LOCATION" 
   (	"CONTAINER_ID" NUMBER, 
	"PARENT_CONTAINER_ID" NUMBER, 
	"TIMESTAMP" DATE
   ) ;
COMMENT ON TABLE "CF_TEMP_CONTAINER_LOCATION" IS 'Deprecated table used by to be removed LoadBarcodes.cfm, functionality moving to use of cf_temp_cont_edit.';
