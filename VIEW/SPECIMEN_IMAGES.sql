
  CREATE OR REPLACE FORCE VIEW "SPECIMEN_IMAGES" ("MEDIA_ID", "MEDIA_URI", "MIME_TYPE", "SUBJECT", "CREATED_DATE", "TAKEN_BY", "CAT_NUM", "INSTITUTION_ACRONYM", "COLLECTION_CDE", "COLLECTION", "MINIMUM_ELEVATION", "MAXIMUM_ELEVATION", "ORIG_ELEV_UNITS", "LAST_EDIT_DATE", "INDIVIDUALCOUNT", "COLL_OBJ_DISPOSITION", "COLLECTORS", "TYPESTATUS", "SEX", "PARTS", "VERBATIM_DATE", "HIGHER_GEOG", "CONTINENT_OCEAN", "COUNTRY", "STATE_PROV", "COUNTY", "FEATURE", "ISLAND", "ISLAND_GROUP", "QUAD", "SEA", "SPEC_LOCALITY", "MIN_ELEV_IN_M", "MAX_ELEV_IN_M", "DEC_LAT", "DEC_LONG", "DATUM", "ORIG_LAT_LONG_UNITS", "VERBATIMLATITUDE", "VERBATIMLONGITUDE", "LAT_LONG_REF_SOURCE", "COORDINATEUNCERTAINTYINMETERS", "GEOREFMETHOD", "LAT_LONG_REMARKS", "LAT_LONG_DETERMINER", "SCIENTIFIC_NAME", "IDENTIFIEDBY", "MADE_DATE", "REMARKS", "HABITAT", "FULL_TAXON_NAME", "PHYLCLASS", "KINGDOM", "PHYLUM", "PHYLORDER", "FAMILY", "GENUS", "SPECIES", "SUBSPECIES", "INFRASPECIFIC_RANK", "AUTHOR_TEXT", "IDENTIFICATIONMODIFIER", "NOMENCLATURAL_CODE", "GUID", "BASISOFRECORD", "DEPTH_UNITS", "MIN_DEPTH", "MAX_DEPTH", "COLLECTING_METHOD", "COLLECTING_SOURCE", "DAYOFYEAR", "AGE_CLASS", "ATTRIBUTES", "VERIFICATIONSTATUS", "SPECIMENDETAILURL", "COLLECTORNUMBER", "VERBATIMELEVATION", "YEAR", "MONTH", "DAY") AS 
  select m.media_id, m.media_uri, m.mime_type, mls.label_value as "SUBJECT", mld.label_value as "MEDIA_CREATED_DATE", an.agent_name as "TAKEN_BY", ff.CAT_NUM, ff. INSTITUTION_ACRONYM, 
ff.COLLECTION_CDE, ff.COLLECTION, ff.MINIMUM_ELEVATION, ff.MAXIMUM_ELEVATION, ff.ORIG_ELEV_UNITS, ff.LAST_EDIT_DATE, ff.INDIVIDUALCOUNT, 
ff.COLL_OBJ_DISPOSITION, ff.COLLECTORS, ff.TYPESTATUS, ff.SEX, ff.PARTS, ff.VERBATIM_DATE, ff.HIGHER_GEOG, ff.CONTINENT_OCEAN, ff.COUNTRY, 
ff.STATE_PROV, ff.COUNTY, ff.FEATURE, ff.ISLAND, ff.ISLAND_GROUP, ff.QUAD, ff.SEA, ff.SPEC_LOCALITY, ff.MIN_ELEV_IN_M, ff.MAX_ELEV_IN_M, 
ff.DEC_LAT, ff.DEC_LONG, ff.DATUM, ff.ORIG_LAT_LONG_UNITS, ff.VERBATIMLATITUDE, ff.VERBATIMLONGITUDE, ff.LAT_LONG_REF_SOURCE, 
ff.COORDINATEUNCERTAINTYINMETERS, ff.GEOREFMETHOD, ff.LAT_LONG_REMARKS, ff.LAT_LONG_DETERMINER, ff.SCIENTIFIC_NAME, ff.IDENTIFIEDBY, 
ff.MADE_DATE, ff.REMARKS, ff.HABITAT, ff.FULL_TAXON_NAME, ff.PHYLCLASS, ff.KINGDOM, ff.PHYLUM, ff.PHYLORDER, ff.FAMILY, ff.GENUS, ff.SPECIES, 
ff.SUBSPECIES, ff.INFRASPECIFIC_RANK, ff.AUTHOR_TEXT, ff.IDENTIFICATIONMODIFIER, ff.NOMENCLATURAL_CODE, ff.GUID, ff.BASISOFRECORD, ff.DEPTH_UNITS, 
ff.MIN_DEPTH, ff.MAX_DEPTH, ff.COLLECTING_METHOD, ff.COLLECTING_SOURCE, ff.DAYOFYEAR, ff.AGE_CLASS, ff.ATTRIBUTES, ff.VERIFICATIONSTATUS, 
'http://mczbase.mcz.harvard.edu/SpecimenDetail.cfm?collection_object_id=' || ff.collection_object_id, ff.COLLECTORNUMBER, ff.VERBATIMELEVATION, ff.YEAR, ff.MONTH, ff.DAY   
from mczbase.media m, (select * from mczbase.media_labels where media_label='subject') mls, mczbase.media_labels mld,
mczbase.media_relations mra, mczbase.media_relations mrci, mczbase.filtered_flat ff, mczbase.agent_name an
where m.media_type = 'image'
and mls.media_id(+) = m.media_id
and mld.media_id=m.media_id
and mld.Media_label='made date'
and mra.media_id = m.media_id
and mra.media_relationship = 'created by agent'
and mra.related_primary_key = an.agent_id
and an.agent_name_type = 'preferred'
and mrci.media_id = m.media_id
and mrci.media_relationship = 'shows cataloged_item'
and mrci.related_primary_key = ff.collection_object_id
 