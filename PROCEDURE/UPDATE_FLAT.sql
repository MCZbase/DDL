
  CREATE OR REPLACE EDITIONABLE PROCEDURE "UPDATE_FLAT" (collobjid IN NUMBER) IS
BEGIN
        UPDATE flat
        SET (
                        cat_num,
                        accn_id,
                        received_from,
                        accession_date,
                        received_date,
                        collecting_event_id,
                        collection_cde,
                        collection_id,
                        catalognumbertext,
                        institution_acronym,
                        collection,
                        began_date,
                        ended_date,
                        verbatim_date,
                        last_edit_date,
                        individualCount,
                        coll_obj_disposition,
                        collectors,
                        RECORDEDBYID,
                        preparators,
                        field_num,
                        otherCatalogNumbers,
                        genbankNum,
                        relatedCatalogedItems,
                        typeStatus,
                        typeStatusWords,
                        typeStatusPlain,
                        sex,
                        parts,
                        partdetail,
                        encumbrances,
                        accession,
                        geog_auth_rec_id,
                        higher_geog,
                        continent_ocean,
                        continent,
                        country,
                        sovereign_nation,
                        state_prov,
                        county,
                        feature,
                        water_feature,
                        waterbody,
                        island,
                        island_group,
                        quad,
                        sea,
                        higherGeographyId,
                        locality_id,
                        spec_locality,
                        minimum_elevation,
                        maximum_elevation,
                        orig_elev_units,
                        min_elev_in_m,
                        max_elev_in_m,
                        dec_lat,
                        dec_long,
                        datum,
                        orig_lat_long_units,
                        verbatimLatitude,
                        verbatimLongitude,
                        verbatimsrs,
                        lat_long_ref_source,
                        coordinateUncertaintyInMeters,
                        coordinate_precision,
                        pointradiusspatialfit,
                        georefMethod,
                        lat_long_remarks,
                        lat_long_determiner,
                        identification_id,
                        scientific_name,
                        taxonId,
                        scientificNameId,
                        identifiedby,
                        identifiedbyid,
                        made_date,
                        remarks,
                        habitat,
                        associated_species,
                        taxa_formula,
                        full_taxon_name,
                        phylclass,
                        kingdom,
                        phylum,
                        phylOrder,
                        subphylum,
                        subclass,
                        infraclass,
                        superorder,
                        suborder,
                        infraorder,
                        superfamily,
                        family,
                        subfamily,
                        tribe,
                        genus,
                        species,
                        subspecies,
                        author_text,
                        nomenclatural_code,
                        infraspecific_rank,
                        identificationModifier,
                        guid,
                        basisOfRecord,
                        depth_units,
                        min_depth,
                        max_depth,
                        min_depth_in_m,
                        max_depth_in_m,
                        collecting_method,
                        collecting_source,
                        dayOfYear,
                        age_class,
                        attributes,
                        verificationStatus,
                        specimenDetailUrl,
                        imageUrl,
                        imageUrlFiltered,
                        fieldNotesUrl,
                        collectorNumber,
                        verbatimElevation,
                        year,
                        month,
                        day,
                        id_sensu,
                        cat_num_prefix,
                        cat_num_integer,
                        cat_num_suffix,
                        total_parts,
                        cited_as,
                        EARLIESTEONORLOWESTEONOTHEM,
                        LATESTEONORHIGHESTEONOTHEM,
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
                        associated_collection,
                        collecting_time,
                        attributes_json,
                        verbatimlocality,
                        associatedsequences,
                        toptypestatuskind,
                        toptypestatus,
                        countrycode,
                        recataloged_fg,
                        locality_remarks,
                        stored_as,
                        rooms,
                        cabinets,
                        drawers
                        ) = (
                SELECT
                        cataloged_item.cat_num,
                        cataloged_item.accn_id,
                        MCZBASE.GET_TRANS_RECIEVEDAGENT(accn.transaction_id),
                        trans.TRANS_DATE,
                        decode(accn.received_date,to_date('1700-01-01','yyyy-mm-dd'),null,accn.received_date),
                        cataloged_item.collecting_event_id,
                        collection.collection_cde,
                        cataloged_item.collection_id,
                        to_char(cataloged_item.cat_num),
                        collection.institution_acronym,
                        collection.collection,
                        collecting_event.began_date,
                        collecting_event.ended_date,
                        collecting_event.verbatim_date,
                        DECODE(coll_object.last_edit_date,
                                NULL, coll_object.coll_object_entered_date,
                                coll_object.last_edit_date),
                        get_individualcount(coll_object.collection_object_id),
                        mczbase.CONCATDISPOSITIONS(cataloged_item.collection_object_id),
                        concatColl(cataloged_item.collection_object_id),
                        mczbase.GET_SOLE_COLLECTOR_GUID(cataloged_item.collection_object_id),
                        concatPrep(cataloged_item.collection_object_id),
                        concatSingleOtherId(cataloged_item.collection_object_id, 'field number'),
                        concatOtherId(cataloged_item.collection_object_id),
                        concatGenbank(cataloged_item.collection_object_id),
                        concatRelations(cataloged_item.collection_object_id),
                        concatTypeStatus(cataloged_item.collection_object_id),
                        MCZBASE.concatTypeStatus_Words(cataloged_item.collection_object_id),
                        MCZBASE.concatTypeStatus_Plain(cataloged_item.collection_object_id),
                        concatAttributeValue(cataloged_item.collection_object_id, 'sex'),
                        concatParts(cataloged_item.collection_object_id),
                        concatPartsDetail(cataloged_item.collection_object_id),
                        concatEncumbrances(cataloged_item.collection_object_id),
                        accn.accn_number,
                        geog_auth_rec.geog_auth_rec_id,
                        geog_auth_rec.higher_geog,
                        geog_auth_rec.continent_ocean,
                        (CASE WHEN geog_auth_rec.continent_ocean like '% Ocean' THEN '' ELSE geog_auth_rec.continent_ocean END) as continent,
                        geog_auth_rec.country,
                        locality.sovereign_nation,
                        geog_auth_rec.state_prov,
                        geog_auth_rec.county,
                        geog_auth_rec.feature,
                        geog_auth_rec.water_feature,
                        decode (water_feature, null, 
                           decode (sea, null, 
                              decode (ocean_subregion, null, 
                                 decode (ocean_region, null, 
                                   decode ( (CASE WHEN continent_ocean like '% Ocean' THEN continent_ocean ELSE '' END), null, 
                                        '', 
                                       (CASE WHEN continent_ocean like '% Ocean' THEN continent_ocean ELSE '' END)
                                   ), 
                                ocean_region),
                              ocean_subregion),
                           sea),
                         water_feature) as  waterbody,
                        geog_auth_rec.island,
                        geog_auth_rec.island_group,
                        geog_auth_rec.quad,
                        geog_auth_rec.sea,
                        geog_auth_rec.higherGeographyID,
                        locality.locality_id,
                        locality.spec_locality,
                        locality.minimum_elevation,
                        locality.maximum_elevation,
                        locality.orig_elev_units,
                        to_meters(locality.minimum_elevation, locality.orig_elev_units),
                        to_meters(locality.maximum_elevation, locality.orig_elev_units),
                        nvl2(accepted_lat_long.coordinate_precision, round(accepted_lat_long.dec_lat,accepted_lat_long.coordinate_precision), round(dec_lat,5)) as dec_lat,
                        nvl2(accepted_lat_long.coordinate_precision, round(accepted_lat_long.dec_long,accepted_lat_long.coordinate_precision), round(dec_long,5)) as dec_long,
                        accepted_lat_long.datum,
                        accepted_lat_long.orig_lat_long_units,
                        /*decode(accepted_lat_long.orig_lat_long_units,
                                'decimal degrees',
                                        to_char(decimalZero(accepted_lat_long.dec_lat)) || 'd',
                                'deg. min. sec.',
                                        to_char(decimalZero(accepted_lat_long.lat_deg)) || 'd ' ||
                                        to_char(decimalZero(accepted_lat_long.lat_min)) || 'm ' ||
                                        to_char(decimalZero(accepted_lat_long.lat_sec)) || 's ' ||
                                        accepted_lat_long.lat_dir,
                                'UTM', 
                                    'UTM N/S: ' || to_char(accepted_lat_long.UTM_NS) 
                                    || '; UTM Zone: ' || 
                                    decode(accepted_lat_long.UTM_ZONE,
                                        null,'not given',
                                        accepted_lat_long.UTM_ZONE
                                    ),
                                'degrees dec. minutes',
                                        to_char(decimalZero(accepted_lat_long.lat_deg)) || 'd ' ||
                                        to_char(decimalZero(accepted_lat_long.dec_lat_min)) || 'm ' ||
                                        accepted_lat_long.lat_dir),
                        decode(accepted_lat_long.orig_lat_long_units,
                                'decimal degrees',
                                        to_char(decimalZero(accepted_lat_long.dec_long)) || 'd',
                                'deg. min. sec.',
                                        to_char(decimalZero(accepted_lat_long.long_deg)) || 'd ' ||
                                        to_char(decimalZero(accepted_lat_long.long_min)) || 'm ' ||
                                        to_char(decimalZero(accepted_lat_long.long_sec)) || 's ' ||
                                        accepted_lat_long.long_dir,
                                'UTM', 
                                    'UTM E/W: ' || to_char(accepted_lat_long.UTM_EW) 
                                    || '; UTM Zone: ' || 
                                    decode(accepted_lat_long.UTM_ZONE,
                                        null,'not given',
                                        accepted_lat_long.UTM_ZONE
                                    ),
                                'degrees dec. minutes',
                                        to_char(decimalZero(accepted_lat_long.long_deg)) || 'd ' ||
                                        to_char(decimalZero(accepted_lat_long.dec_long_min)) || 'm ' ||
                                        accepted_lat_long.long_dir),*/
                        collecting_event.verbatimlatitude,
                        collecting_event.verbatimlongitude,
                        collecting_event.verbatimsrs,
                        accepted_lat_long.lat_long_ref_source,
                        to_meters(accepted_lat_long.max_error_distance, accepted_lat_long.max_error_units),
                        accepted_lat_long.coordinate_precision,
                        accepted_lat_long.spatialfit,
                        accepted_lat_long.georefmethod,
                        accepted_lat_long.lat_long_remarks,
                        lldetr.agent_name,
                        identification.identification_id,
                        identification.scientific_name,
                        taxonomy.taxonId,
                        taxonomy.scientificNameId,
                        concatidentifiers(cataloged_item.collection_object_id),
                        MCZBASE.GET_SOLE_DETERMINER_GUID(cataloged_item.collection_object_id),
                        identification.made_date,
                        coll_object_remark.coll_object_remarks,
                        coll_object_remark.habitat,
                        coll_object_remark.associated_species,
                        taxa_formula,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'full_taxon_name')
                                ELSE full_taxon_name
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'phylclass')
                                ELSE phylclass
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'Kingdom')
                                ELSE kingdom
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'Phylum')
                                ELSE phylum
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'phylOrder')
                                ELSE phylOrder
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'subphylum')
                                ELSE subphylum
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'subclass')
                                ELSE subclass
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'infraclass')
                                ELSE infraclass
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'superorder')
                                ELSE superorder
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'suborder')
                                ELSE suborder
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'infraorder')
                                ELSE infraorder
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'superfamily')
                                ELSE superfamily
                        END,                        
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'Family')
                                ELSE family
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'Subfamily')
                                ELSE subfamily
                        END,
                       CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'Tribe')
                                ELSE tribe
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'Genus')
                                ELSE genus
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'Species')
                                ELSE species
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'Subspecies')
                                ELSE subspecies
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'author_text')
                                ELSE author_text
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'nomenclatural_code')
                                ELSE nomenclatural_code
                        END,
                        CASE WHEN taxa_formula LIKE '%B'
                                THEN get_taxonomy(cataloged_item.collection_object_id, 'infraspecific_rank')
                                ELSE infraspecific_rank
                        END,
                        ' ',
                        collection.guid_prefix || ':' ||
                        cataloged_item.cat_num,
                        decode(cataloged_item.CATALOGED_ITEM_TYPE,
                                'BI', 'PreservedSpecimen',
                                'HO', 'HumanObservation',
                                'FS', 'FossilSpecimen',
                                'Occurrence'),
                        locality.depth_units,
                        locality.min_depth,
                        locality.max_depth,
                        to_meters(locality.min_depth,locality.depth_units),
                        to_meters(locality.max_depth,locality.depth_units),
                        collecting_event.collecting_method,
                        collecting_event.collecting_source,
                        --decode(collecting_event.began_date,
                        --      collecting_event.ended_date, to_number(to_char(collecting_event.began_date, 'DDD')),
                        --      NULL),
                        0,
                        concatAttributeValue(cataloged_item.collection_object_id, 'age class'),
                        concatattribute(cataloged_item.collection_object_id),
                        accepted_lat_long.verificationstatus,
                        '<a href="http://mczbase.mcz.harvard.edu/guid/' ||
                                collection.guid_prefix || ':' ||
                                cataloged_item.cat_num || '">' ||
                                collection.guid_prefix || ':' ||
                                cataloged_item.cat_num || '</a>',
                        concatimageurl(cataloged_item.collection_object_id),
                        mczbase.concatimageurlfiltered(cataloged_item.collection_object_id),
                        'http://mczbase.mcz.harvard.edu/guid/' ||
                                collection.guid_prefix || ':' ||
                                cataloged_item.cat_num,
                        concatSingleOtherId(cataloged_item.collection_object_id,'collector number'),
                        decode(locality.orig_elev_units,
                                NULL, NULL,
                                locality.minimum_elevation || '-' || 
                                        locality.maximum_elevation || ' ' ||
                                        locality.orig_elev_units),
                        -- decode(to_number(to_char(collecting_event.began_date,'YYYY')),to_number(to_char(collecting_event.ended_date,'YYYY')),to_number(to_char(collecting_event.began_date,'YYYY')),NULL),
                        NULL,
                        NULL,
                        NULL,
                        --decode(to_number(to_char(collecting_event.began_date,'MM')),to_number(to_char(collecting_event.ended_date,'MM')),to_number(to_char(collecting_event.began_date,'MM')),NULL),
                        --decode(to_number(to_char(collecting_event.began_date,'DD')),to_number(to_char(collecting_event.ended_date,'DD')),to_number(to_char(collecting_event.began_date,'DD')),NULL),
                        '<a href="http://mczbase.mcz.harvard.edu/publication/' || idpub.publication_id || '">' || idpub.formatted_publication || '</a>',
                        cataloged_item.cat_num_prefix,
                        cataloged_item.cat_num_integer,
                        cataloged_item.cat_num_suffix,
                        sumparts(cataloged_item.collection_object_id),
                        concatcitedas(cataloged_item.collection_object_id),
                        
                        mczbase.get_geol_attr_range(locality.locality_id, 'Eonothem/Eon',1), 
                        mczbase.get_geol_attr_range(locality.locality_id, 'Eonothem/Eon',0),      

                        mczbase.get_geol_attr_range(locality.locality_id, 'Erathem/Era',1), 
                        mczbase.get_geol_attr_range(locality.locality_id, 'Erathem/Era',0), 

                        mczbase.get_geol_attr_range(locality.locality_id, 'Period/System',1), 
                        mczbase.get_geol_attr_range(locality.locality_id, 'Period/System',0), 

                        mczbase.get_geol_attr_range(locality.locality_id, 'Epoch/Series',1), 
                        mczbase.get_geol_attr_range(locality.locality_id, 'Epoch/Series',0), 

                        mczbase.get_geol_attr_range(locality.locality_id, 'Age/Stage',1), 
                        mczbase.get_geol_attr_range(locality.locality_id, 'Age/Stage',0),

                        mczbase.get_lithostratigraphy(locality.locality_id), 

                        nvl(mczbase.get_lithostrat_attr(locality.locality_id,'Group'),mczbase.get_lithostrat_attr(locality.locality_id,'Supergroup')), 
                        mczbase.get_lithostrat_attr(locality.locality_id,'Formation'), 
                        mczbase.get_lithostrat_attr(locality.locality_id,'Member'), 
                        mczbase.get_lithostrat_attr(locality.locality_id,'Bed'),
                        GET_ASSOC_COLLID(cataloged_item.collection_object_id),
                        collecting_event.collecting_time,
                        MCZBASE.concatAttributesJSON(cataloged_item.collection_object_id),
                        collecting_event.verbatim_locality,
                        MCZBASE.GET_GENBANK_LINKS(cataloged_item.collection_object_id),
                        MCZBASE.get_top_typestatus_kind(cataloged_item.collection_object_id),
                        MCZBASE.get_top_typestatus(cataloged_item.collection_object_id),
                        MCZBASE.get_countrycode(geog_auth_rec.country),
                        MCZBASE.is_recataloged(cataloged_item.collection_object_id),
                        locality.locality_remarks,
                        MCZBASE.get_stored_as_id(cataloged_item.collection_object_id),
                        MCZBASE.GET_STORAGE_ROOMS(cataloged_item.collection_object_id), 
                        MCZBASE.GET_STORAGE_CABINETS(cataloged_item.collection_object_id),
                        MCZBASE.GET_STORAGE_DRAWERS(cataloged_item.collection_object_id)
                FROM
                        cataloged_item,
                        coll_object,
                        collection,
                        accn,
                        trans,
                        collecting_event,
                        locality,
                        geog_auth_rec,
                        accepted_lat_long,
                        identification,
                        coll_object_remark,
                        preferred_agent_name lldetr,
                        identification_taxonomy,
                        taxonomy,
                        (SELECT * FROM FORmatted_publication WHERE FORmat_style='short') idpub
                WHERE flat.collection_object_id = cataloged_item.collection_object_id
                        AND cataloged_item.collection_object_id = coll_object.collection_object_id
                        AND cataloged_item.collection_id = collection.collection_id
                        AND cataloged_item.accn_id = accn.transaction_id
                        AND accn.transaction_id = trans.transaction_id
                        AND cataloged_item.collecting_event_id = collecting_event.collecting_event_id
                        AND collecting_event.locality_id = locality.locality_id
                        AND locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id
                        AND locality.locality_id = accepted_lat_long.locality_id (+)
                        AND accepted_lat_long.determined_by_agent_id = lldetr.agent_id (+)
                        AND cataloged_item.collection_object_id = identification.collection_object_id
                        AND identification.accepted_id_fg = 1
                        AND identification.publication_id=idpub.publication_id (+)
                        AND identification.identification_id = identification_taxonomy.identification_id
                        AND identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id
                        AND identification_taxonomy.variable = 'A'
                        AND coll_object.collection_object_id = coll_object_remark.collection_object_id (+))
        WHERE flat.collection_object_id = collobjid;
END;