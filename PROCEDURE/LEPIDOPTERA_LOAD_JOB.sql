
  CREATE OR REPLACE PROCEDURE "LEPIDOPTERA_LOAD_JOB" as

begin
Insert into bulkloader_lepidoptera(
COLLECTION_OBJECT_ID,
COLL_OBJ_DISPOSITION,
CONDITION,
NATURE_OF_ID,
ENTEREDBY,
INSTITUTION_ACRONYM,
COLLECTION_CDE,
ACCN,
CAT_NUM,
COLLECTING_SOURCE,
OTHER_ID_NUM_1,
OTHER_ID_NUM_TYPE_1,
OTHER_ID_NUM_2,
OTHER_ID_NUM_TYPE_2,
OTHER_ID_NUM_3,
OTHER_ID_NUM_TYPE_3,
OTHER_ID_NUM_4,
OTHER_ID_NUM_TYPE_4,
OTHER_ID_NUM_5,
OTHER_ID_NUM_TYPE_5,
ATTRIBUTE_1,
ATTRIBUTE_VALUE_1,
ATTRIBUTE_DETERMINER_1,
ATTRIBUTE_2,
ATTRIBUTE_VALUE_2,
ATTRIBUTE_DETERMINER_2,
ATTRIBUTE_3,
ATTRIBUTE_VALUE_3,
ATTRIBUTE_DETERMINER_3,
ATTRIBUTE_4,
ATTRIBUTE_VALUE_4,
ATTRIBUTE_DETERMINER_4,
ATTRIBUTE_5,
ATTRIBUTE_VALUE_5,
ATTRIBUTE_DETERMINER_5,
MINIMUM_ELEVATION,
MAXIMUM_ELEVATION,
ORIG_ELEV_UNITS,
PART_NAME_1,
PRESERV_METHOD_1,
PART_LOT_COUNT_1,
PART_BARCODE_1,
PART_DISPOSITION_1,
PART_CONDITION_1,
PART_CONTAINER_LABEL_1,

PART_NAME_2,
PRESERV_METHOD_2,
PART_LOT_COUNT_2,
PART_DISPOSITION_2,
PART_CONDITION_2,
PART_NAME_3,
PRESERV_METHOD_3,
PART_LOT_COUNT_3,
PART_DISPOSITION_3,
PART_CONDITION_3,
PART_NAME_4,
PRESERV_METHOD_4,
PART_LOT_COUNT_4,
PART_DISPOSITION_4,
PART_CONDITION_4,
PART_NAME_5,
PRESERV_METHOD_5,
PART_LOT_COUNT_5,
PART_DISPOSITION_5,
PART_CONDITION_5,
PART_NAME_6,
PRESERV_METHOD_6,
PART_LOT_COUNT_6,
PART_DISPOSITION_6,
PART_CONDITION_6,
PART_NAME_7,
PRESERV_METHOD_7,
PART_LOT_COUNT_7,
PART_DISPOSITION_7,
PART_CONDITION_7,
PART_NAME_8,
PRESERV_METHOD_8,
PART_LOT_COUNT_8,
PART_DISPOSITION_8,
PART_CONDITION_8,

TAXON_NAME,
ID_MADE_BY_AGENT,
HIGHER_GEOG,
SPEC_LOCALITY,
VERBATIM_LOCALITY,
COLLECTING_METHOD,
COLLECTOR_AGENT_1,
COLLECTOR_AGENT_2,
COLLECTOR_AGENT_3,
COLLECTOR_AGENT_4,
COLLECTOR_AGENT_5,
COLLECTOR_AGENT_6,
COLLECTOR_AGENT_7,
COLLECTOR_AGENT_8,
COLLECTOR_ROLE_1,
COLLECTOR_ROLE_2,
COLLECTOR_ROLE_3,
COLLECTOR_ROLE_4,
COLLECTOR_ROLE_5,
COLLECTOR_ROLE_6,
COLLECTOR_ROLE_7,
COLLECTOR_ROLE_8,
VERBATIM_DATE,
BEGAN_DATE,
ENDED_DATE,
ATTRIBUTE_7,
ATTRIBUTE_VALUE_7,
ATTRIBUTE_DETERMINER_7,
ATTRIBUTE_8,
ATTRIBUTE_VALUE_8,
ATTRIBUTE_DETERMINER_8,
ATTRIBUTE_9,
ATTRIBUTE_VALUE_9,
ATTRIBUTE_DETERMINER_9,
COLL_OBJECT_REMARKS,
HABITAT_DESC,
COLL_OBJECT_HABITAT,

part_1_att_name_1,
part_1_att_val_1,
part_1_att_units_1,
part_1_att_detby_1,
part_1_att_madedate_1,
part_1_att_rem_1,

part_1_att_name_2,
part_1_att_val_2,
part_1_att_units_2,
part_1_att_detby_2,
part_1_att_madedate_2,
part_1_att_rem_2,
    
part_1_att_name_3,
part_1_att_val_3,
part_1_att_units_3,
part_1_att_detby_3,
part_1_att_madedate_3,
part_1_att_rem_3,    
    
part_1_att_name_4,
part_1_att_val_4,
part_1_att_units_4,
part_1_att_detby_4,
part_1_att_madedate_4,
part_1_att_rem_4,    
    
part_2_att_name_1,
part_2_att_val_1,
part_2_att_units_1,
part_2_att_detby_1,
part_2_att_madedate_1,
part_2_att_rem_1,

part_2_att_name_2,
part_2_att_val_2,
part_2_att_units_2,
part_2_att_detby_2,
part_2_att_madedate_2,
part_2_att_rem_2,
    
part_2_att_name_3,
part_2_att_val_3,
part_2_att_units_3,
part_2_att_detby_3,
part_2_att_madedate_3,
part_2_att_rem_3,    
    
part_2_att_name_4,
part_2_att_val_4,
part_2_att_units_4,
part_2_att_detby_4,
part_2_att_madedate_4,
part_2_att_rem_4,    
    
part_3_att_name_1,
part_3_att_val_1,
part_3_att_units_1,
part_3_att_detby_1,
part_3_att_madedate_1,
part_3_att_rem_1,

part_3_att_name_2,
part_3_att_val_2,
part_3_att_units_2,
part_3_att_detby_2,
part_3_att_madedate_2,
part_3_att_rem_2,

part_3_att_name_3,
part_3_att_val_3,
part_3_att_units_3,
part_3_att_detby_3,
part_3_att_madedate_3,
part_3_att_rem_3,

part_3_att_name_4,
part_3_att_val_4,
part_3_att_units_4,
part_3_att_detby_4,
part_3_att_madedate_4,
part_3_att_rem_4,

part_4_att_name_1,
part_4_att_val_1,
part_4_att_units_1,
part_4_att_detby_1,
part_4_att_madedate_1,
part_4_att_rem_1,

part_4_att_name_2,
part_4_att_val_2,
part_4_att_units_2,
part_4_att_detby_2,
part_4_att_madedate_2,
part_4_att_rem_2,

part_4_att_name_3,
part_4_att_val_3,
part_4_att_units_3,
part_4_att_detby_3,
part_4_att_madedate_3,
part_4_att_rem_3,

part_4_att_name_4,
part_4_att_val_4,
part_4_att_units_4,
part_4_att_detby_4,
part_4_att_madedate_4,
part_4_att_rem_4,

part_5_att_name_1,
part_5_att_val_1,
part_5_att_units_1,
part_5_att_detby_1,
part_5_att_madedate_1,
part_5_att_rem_1,

part_5_att_name_2,
part_5_att_val_2,
part_5_att_units_2,
part_5_att_detby_2,
part_5_att_madedate_2,
part_5_att_rem_2,

part_5_att_name_3,
part_5_att_val_3,
part_5_att_units_3,
part_5_att_detby_3,
part_5_att_madedate_3,
part_5_att_rem_3,

part_5_att_name_4,
part_5_att_val_4,
part_5_att_units_4,
part_5_att_detby_4,
part_5_att_madedate_4,
part_5_att_rem_4,

part_6_att_name_1,
part_6_att_val_1,
part_6_att_units_1,
part_6_att_detby_1,
part_6_att_madedate_1,
part_6_att_rem_1,

part_6_att_name_2,
part_6_att_val_2,
part_6_att_units_2,
part_6_att_detby_2,
part_6_att_madedate_2,
part_6_att_rem_2,

part_6_att_name_3,
part_6_att_val_3,
part_6_att_units_3,
part_6_att_detby_3,
part_6_att_madedate_3,
part_6_att_rem_3,

part_6_att_name_4,
part_6_att_val_4,
part_6_att_units_4,
part_6_att_detby_4,
part_6_att_madedate_4,
part_6_att_rem_4,
    
part_7_att_name_1,
part_7_att_val_1,
part_7_att_units_1,
part_7_att_detby_1,
part_7_att_madedate_1,
part_7_att_rem_1,

part_7_att_name_2,
part_7_att_val_2,
part_7_att_units_2,
part_7_att_detby_2,
part_7_att_madedate_2,
part_7_att_rem_2,

part_7_att_name_3,
part_7_att_val_3,
part_7_att_units_3,
part_7_att_detby_3,
part_7_att_madedate_3,
part_7_att_rem_3,

part_7_att_name_4,
part_7_att_val_4,
part_7_att_units_4,
part_7_att_detby_4,
part_7_att_madedate_4,
part_7_att_rem_4,

part_8_att_name_1,
part_8_att_val_1,
part_8_att_units_1,
part_8_att_detby_1,
part_8_att_madedate_1,
part_8_att_rem_1,

part_8_att_name_2,
part_8_att_val_2,
part_8_att_units_2,
part_8_att_detby_2,
part_8_att_madedate_2,
part_8_att_rem_2,

part_8_att_name_3,
part_8_att_val_3,
part_8_att_units_3,
part_8_att_detby_3,
part_8_att_madedate_3,
part_8_att_rem_3,

part_8_att_name_4,
part_8_att_val_4,
part_8_att_units_4,
part_8_att_detby_4,
part_8_att_madedate_4,
part_8_att_rem_4,

ORIG_LAT_LONG_UNITS,
DEC_LAT,
DEC_LONG,
LATDEG,
DEC_LAT_MIN,
LATMIN,
LATSEC,
LATDIR,
LONGDEG,
DEC_LONG_MIN,
LONGMIN,
LONGSEC,
LONGDIR,
DATUM,
LAT_LONG_REF_SOURCE,
MAX_ERROR_DISTANCE,
MAX_ERROR_UNITS,
GEOREFMETHOD,
DETERMINED_BY_AGENT,
DETERMINED_DATE,
LAT_LONG_REMARKS,
VERIFICATIONSTATUS


)
select
COLLECTION_OBJECT_ID,
COLL_OBJ_DISPOSITION,
CONDITION,
NATURE_OF_ID,
ENTEREDBY,
INSTITUTION_ACRONYM,
COLLECTION_CDE,
ACCN,
CAT_NUM,
COLLECTING_SOURCE,
OTHER_ID_NUM_1,
OTHER_ID_NUM_TYPE_1,
OTHER_ID_NUM_2,
OTHER_ID_NUM_TYPE_2,
OTHER_ID_NUM_3,
OTHER_ID_NUM_TYPE_3,
OTHER_ID_NUM_4,
OTHER_ID_NUM_TYPE_4,
OTHER_ID_NUM_5,
OTHER_ID_NUM_TYPE_5,
ATTRIBUTE_1,
ATTRIBUTE_VALUE_1,
ATTRIBUTE_DETERMINER_1,
ATTRIBUTE_2,
ATTRIBUTE_VALUE_2,
ATTRIBUTE_DETERMINER_2,
ATTRIBUTE_3,
ATTRIBUTE_VALUE_3,
ATTRIBUTE_DETERMINER_3,
ATTRIBUTE_4,
ATTRIBUTE_VALUE_4,
ATTRIBUTE_DETERMINER_4,
ATTRIBUTE_5,
ATTRIBUTE_VALUE_5,
ATTRIBUTE_DETERMINER_5,
MINIMUM_ELEVATION,
MAXIMUM_ELEVATION,
ORIG_ELEV_UNITS,
PART_NAME_1,
PRESERV_METHOD_1,
PART_LOT_COUNT_1,
PART_BARCODE_1,
PART_DISPOSITION_1,
PART_CONDITION_1,
PART_CONTAINER_LABEL_1,

PART_NAME_2,
PRESERV_METHOD_2,
PART_LOT_COUNT_2,
PART_DISPOSITION_2,
PART_CONDITION_2,
PART_NAME_3,
PRESERV_METHOD_3,
PART_LOT_COUNT_3,
PART_DISPOSITION_3,
PART_CONDITION_3,
PART_NAME_4,
PRESERV_METHOD_4,
PART_LOT_COUNT_4,
PART_DISPOSITION_4,
PART_CONDITION_4,
PART_NAME_5,
PRESERV_METHOD_5,
PART_LOT_COUNT_5,
PART_DISPOSITION_5,
PART_CONDITION_5,
PART_NAME_6,
PRESERV_METHOD_6,
PART_LOT_COUNT_6,
PART_DISPOSITION_6,
PART_CONDITION_6,
PART_NAME_7,
PRESERV_METHOD_7,
PART_LOT_COUNT_7,
PART_DISPOSITION_7,
PART_CONDITION_7,
PART_NAME_8,
PRESERV_METHOD_8,
PART_LOT_COUNT_8,
PART_DISPOSITION_8,
PART_CONDITION_8,

TAXON_NAME,
ID_MADE_BY_AGENT,
HIGHER_GEOG,
SPEC_LOCALITY,
VERBATIM_LOCALITY,
COLLECTING_METHOD,
COLLECTOR_AGENT_1,
COLLECTOR_AGENT_2,
COLLECTOR_AGENT_3,
COLLECTOR_AGENT_4,
COLLECTOR_AGENT_5,
COLLECTOR_AGENT_6,
COLLECTOR_AGENT_7,
COLLECTOR_AGENT_8,
COLLECTOR_ROLE_1,
COLLECTOR_ROLE_2,
COLLECTOR_ROLE_3,
COLLECTOR_ROLE_4,
COLLECTOR_ROLE_5,
COLLECTOR_ROLE_6,
COLLECTOR_ROLE_7,
COLLECTOR_ROLE_8,
VERBATIM_DATE,
BEGAN_DATE,
ENDED_DATE,
ATTRIBUTE_7,
ATTRIBUTE_VALUE_7,
ATTRIBUTE_DETERMINER_7,
ATTRIBUTE_8,
ATTRIBUTE_VALUE_8,
ATTRIBUTE_DETERMINER_8,
ATTRIBUTE_9,
ATTRIBUTE_VALUE_9,
ATTRIBUTE_DETERMINER_9,
trim(TYPESTATUS || ' ' || COLL_OBJECT_REMARKS),
HABITAT_DESC,
COLL_OBJECT_HABITAT, 

part_1_att_name_1,
part_1_att_val_1,
part_1_att_units_1,
part_1_att_detby_1,
part_1_att_madedate_1,
part_1_att_rem_1,

part_1_att_name_2,
part_1_att_val_2,
part_1_att_units_2,
part_1_att_detby_2,
part_1_att_madedate_2,
part_1_att_rem_2,
    
part_1_att_name_3,
part_1_att_val_3,
part_1_att_units_3,
part_1_att_detby_3,
part_1_att_madedate_3,
part_1_att_rem_3,    
    
part_1_att_name_4,
part_1_att_val_4,
part_1_att_units_4,
part_1_att_detby_4,
part_1_att_madedate_4,
part_1_att_rem_4,    
    
part_2_att_name_1,
part_2_att_val_1,
part_2_att_units_1,
part_2_att_detby_1,
part_2_att_madedate_1,
part_2_att_rem_1,

part_2_att_name_2,
part_2_att_val_2,
part_2_att_units_2,
part_2_att_detby_2,
part_2_att_madedate_2,
part_2_att_rem_2,
    
part_2_att_name_3,
part_2_att_val_3,
part_2_att_units_3,
part_2_att_detby_3,
part_2_att_madedate_3,
part_2_att_rem_3,    
    
part_2_att_name_4,
part_2_att_val_4,
part_2_att_units_4,
part_2_att_detby_4,
part_2_att_madedate_4,
part_2_att_rem_4,    
    
part_3_att_name_1,
part_3_att_val_1,
part_3_att_units_1,
part_3_att_detby_1,
part_3_att_madedate_1,
part_3_att_rem_1,

part_3_att_name_2,
part_3_att_val_2,
part_3_att_units_2,
part_3_att_detby_2,
part_3_att_madedate_2,
part_3_att_rem_2,

part_3_att_name_3,
part_3_att_val_3,
part_3_att_units_3,
part_3_att_detby_3,
part_3_att_madedate_3,
part_3_att_rem_3,

part_3_att_name_4,
part_3_att_val_4,
part_3_att_units_4,
part_3_att_detby_4,
part_3_att_madedate_4,
part_3_att_rem_4,

part_4_att_name_1,
part_4_att_val_1,
part_4_att_units_1,
part_4_att_detby_1,
part_4_att_madedate_1,
part_4_att_rem_1,

part_4_att_name_2,
part_4_att_val_2,
part_4_att_units_2,
part_4_att_detby_2,
part_4_att_madedate_2,
part_4_att_rem_2,

part_4_att_name_3,
part_4_att_val_3,
part_4_att_units_3,
part_4_att_detby_3,
part_4_att_madedate_3,
part_4_att_rem_3,

part_4_att_name_4,
part_4_att_val_4,
part_4_att_units_4,
part_4_att_detby_4,
part_4_att_madedate_4,
part_4_att_rem_4,

part_5_att_name_1,
part_5_att_val_1,
part_5_att_units_1,
part_5_att_detby_1,
part_5_att_madedate_1,
part_5_att_rem_1,

part_5_att_name_2,
part_5_att_val_2,
part_5_att_units_2,
part_5_att_detby_2,
part_5_att_madedate_2,
part_5_att_rem_2,

part_5_att_name_3,
part_5_att_val_3,
part_5_att_units_3,
part_5_att_detby_3,
part_5_att_madedate_3,
part_5_att_rem_3,

part_5_att_name_4,
part_5_att_val_4,
part_5_att_units_4,
part_5_att_detby_4,
part_5_att_madedate_4,
part_5_att_rem_4,

part_6_att_name_1,
part_6_att_val_1,
part_6_att_units_1,
part_6_att_detby_1,
part_6_att_madedate_1,
part_6_att_rem_1,

part_6_att_name_2,
part_6_att_val_2,
part_6_att_units_2,
part_6_att_detby_2,
part_6_att_madedate_2,
part_6_att_rem_2,

part_6_att_name_3,
part_6_att_val_3,
part_6_att_units_3,
part_6_att_detby_3,
part_6_att_madedate_3,
part_6_att_rem_3,

part_6_att_name_4,
part_6_att_val_4,
part_6_att_units_4,
part_6_att_detby_4,
part_6_att_madedate_4,
part_6_att_rem_4,
    
part_7_att_name_1,
part_7_att_val_1,
part_7_att_units_1,
part_7_att_detby_1,
part_7_att_madedate_1,
part_7_att_rem_1,

part_7_att_name_2,
part_7_att_val_2,
part_7_att_units_2,
part_7_att_detby_2,
part_7_att_madedate_2,
part_7_att_rem_2,

part_7_att_name_3,
part_7_att_val_3,
part_7_att_units_3,
part_7_att_detby_3,
part_7_att_madedate_3,
part_7_att_rem_3,

part_7_att_name_4,
part_7_att_val_4,
part_7_att_units_4,
part_7_att_detby_4,
part_7_att_madedate_4,
part_7_att_rem_4,

part_8_att_name_1,
part_8_att_val_1,
part_8_att_units_1,
part_8_att_detby_1,
part_8_att_madedate_1,
part_8_att_rem_1,

part_8_att_name_2,
part_8_att_val_2,
part_8_att_units_2,
part_8_att_detby_2,
part_8_att_madedate_2,
part_8_att_rem_2,

part_8_att_name_3,
part_8_att_val_3,
part_8_att_units_3,
part_8_att_detby_3,
part_8_att_madedate_3,
part_8_att_rem_3,

part_8_att_name_4,
part_8_att_val_4,
part_8_att_units_4,
part_8_att_detby_4,
part_8_att_madedate_4,
part_8_att_rem_4,

ORIG_LAT_LONG_UNITS,
DEC_LAT,
DEC_LONG,
LATDEG,
DEC_LAT_MIN,
LATMIN,
LATSEC,
LATDIR,
LONGDEG,
DEC_LONG_MIN,
LONGMIN,
LONGSEC,
LONGDIR,
DATUM,
LAT_LONG_REF_SOURCE,
MAX_ERROR_DISTANCE,
MAX_ERROR_UNITS,
GEOREFMETHOD,
DETERMINED_BY_AGENT,
DETERMINED_DATE,
LAT_LONG_REMARKS,
VERIFICATIONSTATUS

from specimens_for_load@lepidoptera where (flaginbulkloader=0 or flaginbulkloader is null);

update specimen@lepidoptera set flaginbulkloader=1, workflowstatus = 'Moved to MCZbase' where specimenid in
(select collection_object_id from bulkloader_lepidoptera);

commit;

bulk_lepidoptera_pkg.check_and_load;

bulk_lep_images;

bulk_lep_determinations;

update specimen@lepidoptera set flagancilaryalsoinmczbase=1 
  where specimenid in (select specimenid from bulkloader_lepidoptera_map where imagesloaded=1 AND deterloaded = 1) and flagancilaryalsoinmczbase <> 1;
commit;
end;