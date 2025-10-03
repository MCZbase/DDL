
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FILTERED_FLAT" ("COLLECTION_OBJECT_ID", "CAT_NUM", "ACCN_ID", "INSTITUTION_ACRONYM", "COLLECTION_CDE", "COLLECTION_ID", "COLLECTION", "MINIMUM_ELEVATION", "MAXIMUM_ELEVATION", "ORIG_ELEV_UNITS", "IDENTIFICATION_ID", "LAST_EDIT_DATE", "INDIVIDUALCOUNT", "COLL_OBJ_DISPOSITION", "COLLECTORS", "PREPARATORS", "FIELD_NUM", "OTHERCATALOGNUMBERS", "GENBANKNUM", "RELATEDCATALOGEDITEMS", "TYPESTATUS", "TYPESTATUSWORDS", "TYPESTATUSPLAIN", "SEX", "PARTS", "PARTDETAIL", "ACCESSION", "RECEIVED_FROM", "ACCESSION_DATE", "RECEIVED_DATE", "BEGAN_DATE", "ENDED_DATE", "VERBATIM_DATE", "ISO_BEGAN_DATE", "ISO_ENDED_DATE", "COLLECTING_EVENT_ID", "HIGHER_GEOG", "HIGHERGEOGRAPHYID", "CONTINENT_OCEAN", "CONTINENT", "WATERBODY", "COUNTRY", "SOVEREIGN_NATION", "STATE_PROV", "COUNTY", "FEATURE", "WATER_FEATURE", "ISLAND", "ISLAND_GROUP", "QUAD", "SEA", "GEOG_AUTH_REC_ID", "SPEC_LOCALITY", "MIN_ELEV_IN_M", "MAX_ELEV_IN_M", "LOCALITY_ID", "LOCALITY_REMARKS", "DEC_LAT", "DEC_LONG", "DATUM", "ORIG_LAT_LONG_UNITS", "VERBATIMLATITUDE", "VERBATIMLONGITUDE", "LAT_LONG_REF_SOURCE", "COORDINATEUNCERTAINTYINMETERS", "GEOREFMETHOD", "LAT_LONG_REMARKS", "LAT_LONG_DETERMINER", "SCIENTIFIC_NAME", "SCIENTIFICNAMEID", "TAXONID", "IDENTIFIEDBY", "MADE_DATE", "REMARKS", "HABITAT", "ASSOCIATED_SPECIES", "ENCUMBRANCES", "TAXA_FORMULA", "FULL_TAXON_NAME", "PHYLCLASS", "KINGDOM", "PHYLUM", "PHYLORDER", "FAMILY", "GENUS", "SPECIES", "SUBSPECIES", "INFRASPECIFIC_RANK", "AUTHOR_TEXT", "IDENTIFICATIONMODIFIER", "NOMENCLATURAL_CODE", "GUID", "BASISOFRECORD", "DEPTH_UNITS", "MIN_DEPTH", "MAX_DEPTH", "MIN_DEPTH_IN_M", "MAX_DEPTH_IN_M", "COLLECTING_METHOD", "COLLECTING_SOURCE", "DAYOFYEAR", "AGE_CLASS", "ATTRIBUTES", "VERIFICATIONSTATUS", "SPECIMENDETAILURL", "IMAGEURL", "IMAGEURLFILTERED", "FIELDNOTESURL", "CATALOGNUMBERTEXT", "RELATEDINFORMATION", "COLLECTORNUMBER", "VERBATIMELEVATION", "YEAR", "MONTH", "DAY", "ID_SENSU", "EMPTYSTRING", "CAT_NUM_PREFIX", "CAT_NUM_INTEGER", "CAT_NUM_SUFFIX", "TOTAL_PARTS", "CITED_AS", "EARLIESTEONORLOWESTEONOTHEM", "LATESTEONORHIGHESTEONOTHEM", "EARLIESTERAORLOWESTERATHEM", "LATESTERAORHIGHESTERATHEM", "EARLIESTPERIODORLOWESTSYSTEM", "LATESTPERIODORHIGHESTSYSTEM", "EARLIESTEPOCHORLOWESTSERIES", "LATESTEPOCHORHIGHESTSERIES", "EARLIESTAGEORLOWESTSTAGE", "LATESTAGEORHIGHESTSTAGE", "LITHOSTRATIGRAPHICTERMS", "GEOL_GROUP", "FORMATION", "MEMBER", "BED", "ASSOCIATED_COLLECTION", "COLLECTING_TIME", "ATTRIBUTES_JSON", "VERBATIMLOCALITY", "ASSOCIATEDSEQUENCES", "TOPTYPESTATUSKIND", "TOPTYPESTATUS", "COUNTRYCODE", "RECATALOGED_FG", "RECORDEDBYID", "IDENTIFIEDBYID", "GEOREFERENCEDBYID", "STORED_AS", "ROOMS", "CABINETS", "DRAWERS", "SUBFAMILY", "TRIBE", "SUBPHYLUM", "SUBCLASS", "INFRACLASS", "SUPERORDER", "SUBORDER", "INFRAORDER", "SUPERFAMILY", "COORDINATE_PRECISION", "POINTRADIUSSPATIALFIT", "VERBATIMSRS") AS 
  SELECT collection_object_id,
    cat_num,
    accn_id,
    institution_acronym,
    collection_cde,
    collection_id,
    collection,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN null
      ELSE minimum_elevation
    END minimum_elevation,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN null
      ELSE maximum_elevation
    END maximum_elevation,
    orig_elev_units,
    identification_id,
    last_edit_date,
    individualcount,
    coll_obj_disposition,
    -- mask collector
    CASE
      WHEN encumbrances LIKE '%mask collector%'
      THEN 'Anonymous'
      ELSE collectors
    END collectors,
    CASE
      WHEN encumbrances LIKE '%mask preparator%'
      THEN 'Anonymous'
      ELSE preparators
    END preparators,
    -- mask original field number
    CASE
      WHEN encumbrances LIKE '%mask original field number%'
      THEN 'Anonymous'
      ELSE field_num
    END field_num,
    otherCatalogNumbers,
    genbankNum,
    relatedCatalogedItemS,
    typeStatus,
    typeStatusWords,
    typeStatusPlain,
    sex,
    CASE
      WHEN encumbrances LIKE '%mask parts%'
      THEN 'Call for detailed information'
      else parts
    END parts,
    CASE
      WHEN encumbrances LIKE '%mask parts%'
      THEN 'Call for detailed information'
      else partdetail
    END partdetail,
    accession,  -- accession metadata is redacted.
    '' as received_from,
    '' as accession_date,
    '' as received_date,
    -- mask original field number
    CASE
      WHEN encumbrances LIKE '%mask year collected%'
      THEN REPLACE(began_date,SUBSTR(began_date,1,4),'8888')
      ELSE began_date
    END began_date,
    CASE
      WHEN encumbrances LIKE '%mask year collected%'
      THEN REPLACE(ended_date,SUBSTR(ended_date,1,4),'8888')
      ELSE ended_date
    END ended_date,
    CASE
      WHEN encumbrances LIKE '%mask year collected%'
      THEN 'Masked'
      ELSE verbatim_date
    END verbatim_date,
    CASE
      WHEN encumbrances LIKE '%mask year collected%'
      THEN ''
      ELSE iso_began_date
    END iso_began_date,   
    CASE
      WHEN encumbrances LIKE '%mask year collected%'
      THEN ''
      ELSE iso_ended_date
    END iso_ended_date,   
    collecting_event_id,
    higher_geog,
    highergeographyid,
    continent_ocean,
    continent,
    waterbody,
    country,
    sovereign_nation,
    state_prov,
    county,
    feature,
    water_feature,
    island,
    island_group,
    quad,
    sea,
    geog_auth_rec_id,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN 'Masked. Call for detailed locality'
      ELSE spec_locality
    END spec_locality,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN null
      else min_elev_in_m
    END min_elev_in_m,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN null
      else max_elev_in_m
    END max_elev_in_m,    
    locality_id,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN '[Masked]'
      else locality_remarks
    END locality_remarks,     
    -- mask coordinates
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN NULL
      ELSE dec_lat
    END dec_lat,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN NULL
      ELSE dec_long
    END dec_long,
    datum,
    orig_lat_long_units,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN 'Masked'
      ELSE verbatimlatitude
    END verbatimlatitude,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN 'Masked'
      ELSE verbatimlongitude
    END verbatimlongitude,
    lat_long_ref_source,
    coordinateuncertaintyinmeters,
    georefmethod,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN 'Masked'
      ELSE lat_long_remarks
    END lat_long_remarks,
    lat_long_determiner,
    scientific_name,
    scientificnameid,
    taxonid,
    identifiedby,
    made_date,
    CASE
      WHEN encumbrances LIKE '%mask parts%'
      THEN 'Call for detailed information'
      else remarks
    END remarks,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN '[Masked]'
      else habitat
    END habitat, 
    associated_species,
    encumbrances,
    taxa_formula,
    full_taxon_name,
    phylClass,
    kingdom,
    phylum,
    phylOrder,
    family,
    genus,
    species,
    subspecies,
    infraspecific_rank,
    author_text,
    identificationModifier,
    nomenclatural_code,
    guid,
    basisOfRecord,
    depth_units,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN null
      else min_depth
    END min_depth, 
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN null
      else max_depth
    END max_depth,     
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN null
      else min_depth_in_m
    END min_depth_in_m, 
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN null
      else max_depth_in_m
    END max_depth_in_m,
    collecting_method,
    collecting_source,
    dayOfYear,
    age_class,
    attributes,
    verificationStatus,
    specimenDetailUrl,
    imageUrlFiltered as imageUrl,
    imageUrlFiltered as imageUrlFiltered,
    fieldNotesUrl,
    catalogNumberText,
    '<a href="http://mczbase.mcz.harvard.edu/guid/'
    || guid
    || '">'
    || guid
    || '</a>' RelatedInformation,
    collectorNumber,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN '[Masked]'
      else verbatimelEvation
    END verbatimelEvation,
    CASE
      WHEN encumbrances LIKE '%mask year collected%'
      THEN 8888
      ELSE YEAR
    END YEAR,
    MONTH,
    DAY,
    id_sensu,
    '' emptystring,
    cat_num_prefix,
    cat_num_integer,
    cat_num_suffix,
    CASE 
      when encumbrances LIKE '%mask parts%'
      then 0
      ELSE total_parts
    END TOTAL_PARTS,
    cited_as,
    EARLIESTEONORLOWESTEONOTHEM,
    LatestEonOrHighestEONOTHEM,
    earliestEraOrLowestErathem,
    latestEraOrHighestErathem,
    earliestPeriodOrLowestSystem,
    latestPeriodOrHighestSystem,
    earliestEpochOrLowestSeries,
    latestEpochOrHighestSeries,
    earliestAgeOrLowestStage,
    latestAgeOrHighestStage,
    lithostratigraphicTerms,
    geol_group,
    formation,
    member,
    bed,
    ASSOCIATED_COLLECTION,
    collecting_time,
    ATTRIBUTES_JSON,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN 'Masked. Call for detailed locality'
      ELSE VERBATIMLOCALITY
    END VERBATIMLOCALITY,
    ASSOCIATEDSEQUENCES, 
    toptypestatuskind,
    toptypestatus,
    countrycode,
    recataloged_fg,
    recordedbyid,
    identifiedbyid,
    georeferencedbyid,
    stored_as,
    '' as rooms,
    '' as cabinets,
    '' as drawers,
    subfamily,
    tribe,
    subphylum,
    subclass,
    infraclass,
    superorder,
    suborder,
    infraorder,
    superfamily,
    coordinate_precision,
    pointradiusspatialfit,
    CASE
      WHEN encumbrances LIKE '%mask locality%'
      THEN ''
      ELSE VERBATIMSRS
      END as VERBATIMSRS
  FROM flat
  WHERE
    -- exclude masked records
    (encumbrances IS NULL
  OR encumbrances NOT LIKE '%mask record%')
    --exclude genus Homo
  and nvl(genus,'XXX') <> 'Homo'