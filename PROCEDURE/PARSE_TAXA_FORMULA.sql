
  CREATE OR REPLACE EDITIONABLE PROCEDURE "PARSE_TAXA_FORMULA" (
	p_taxon_name IN VARCHAR2,
	p_taxa_formula OUT VARCHAR2,
	p_taxa_one OUT VARCHAR2,
	p_taxa_two OUT VARCHAR2
) IS
	-- Splits a bulkloader taxon_name into the taxa formula and the taxon names it is composed of,
	-- by the formulas in MCZBASE.CTTAXA_FORMULA, for MCZBASE.BULKLOADER_STAGE_CHECK,
	-- MCZBASE.BULK_CHECK_ONE and MCZBASE.BULK_PKG.b_build_keys_table, so that all three recognise
	-- exactly the formulas the code table holds, and a formula added to the code table needs no
	-- code change.  Replaces the if instr(taxon_name,' or ') ... elsif ... chain each of them held,
	-- which had drifted apart and from the code table.  Matching is case sensitive, as that
	-- parsing was.
	--
	-- A taxon_name can be ingested when some reading of it under a formula gives taxa that each
	-- match exactly one valid catalog term (taxonomy.valid_catalog_term_fg = 1), with no "sp." or
	-- "?" left on either taxon of a two taxon formula; those are the rules b_build_keys_table
	-- applies before it creates the identification.  Readings are tried in this order:
	--   two taxon formulas first, then longer formulas before shorter, so 'A sp. ?' is tried
	--   before 'A ?' and 'A nr. B' before 'A nr.', and 'A', the whole name as one taxon, last;
	--   within a two taxon formula, each place its separator occurs, first to last.
	-- The first reading that can be ingested is returned.  Where the hard coded parsing knew the
	-- formula, that is the reading it took whenever that one could be ingested; a name it rejected
	-- is accepted only when another reading can be ingested, for example a valid taxon whose own
	-- name contains " x ".  The one change to names that loaded before: a name that is itself a
	-- valid taxon and ends in a formula the hard coded parsing did not know, such as
	-- "Ancillaria inflata var.", loaded as that taxon (formula A) and now loads by the formula
	-- (A var. with Ancillaria inflata) when that reading can be ingested, as "Aleochara spp."
	-- always loaded as A spp. with Aleochara.  When no reading can be ingested, the
	-- first reading that fits a formula is returned, so the callers' "Taxonomy (...) not found"
	-- messages name the same taxon as before.  No formula is returned only when the name fits
	-- none, which with 'A' in the code table means an empty name.
	--
	-- @param p_taxon_name the taxon_name from bulkloader or bulkloader_stage.
	-- @param p_taxa_formula returns the formula, a value of CTTAXA_FORMULA.TAXA_FORMULA, or null.
	-- @param p_taxa_one returns the taxon name for A, trimmed, or null.
	-- @param p_taxa_two returns the taxon name for B, trimmed, or null for a one taxon formula.
	-- @see MCZBASE.TAXA_FORMULA_PATTERN
	l_pattern VARCHAR2(4000);
	l_two_taxa BOOLEAN;
	l_separator VARCHAR2(25);
	l_position NUMBER;
	l_occurrence NUMBER;
	l_one VARCHAR2(4000);
	l_two VARCHAR2(4000);
	l_done BOOLEAN := FALSE;

	-- whether a reading can be ingested: each taxon one valid catalog term, no sp. or ? with two taxa
	FUNCTION ingestible(p_one VARCHAR2, p_two VARCHAR2) RETURN BOOLEAN IS
		num NUMBER;
	BEGIN
		IF p_one IS NULL THEN
			RETURN FALSE;
		END IF;
		IF p_two IS NOT NULL AND (
				SUBSTR(p_one, LENGTH(p_one) - 3) = ' sp.' OR SUBSTR(p_two, LENGTH(p_two) - 3) = ' sp.' OR
				SUBSTR(p_one, LENGTH(p_one) - 1) = ' ?' OR SUBSTR(p_two, LENGTH(p_two) - 1) = ' ?') THEN
			RETURN FALSE;
		END IF;
		SELECT COUNT(DISTINCT taxon_name_id) INTO num FROM MCZBASE.taxonomy
		WHERE scientific_name = p_one AND valid_catalog_term_fg = 1;
		IF num <> 1 THEN
			RETURN FALSE;
		END IF;
		IF p_two IS NOT NULL THEN
			SELECT COUNT(DISTINCT taxon_name_id) INTO num FROM MCZBASE.taxonomy
			WHERE scientific_name = p_two AND valid_catalog_term_fg = 1;
			IF num <> 1 THEN
				RETURN FALSE;
			END IF;
		END IF;
		RETURN TRUE;
	END;

	-- keep the first reading that fits a formula, and stop at the first that can be ingested
	PROCEDURE consider(p_formula VARCHAR2, p_one VARCHAR2, p_two VARCHAR2) IS
	BEGIN
		IF p_taxa_formula IS NULL THEN
			p_taxa_formula := p_formula;
			p_taxa_one := p_one;
			p_taxa_two := p_two;
		END IF;
		IF ingestible(p_one, p_two) THEN
			p_taxa_formula := p_formula;
			p_taxa_one := p_one;
			p_taxa_two := p_two;
			l_done := TRUE;
		END IF;
	END;
BEGIN
	p_taxa_formula := NULL;
	p_taxa_one := NULL;
	p_taxa_two := NULL;
	FOR f IN (
		SELECT taxa_formula
		FROM MCZBASE.cttaxa_formula
		ORDER BY
			CASE WHEN REGEXP_LIKE(taxa_formula, '(^| )B( |$)') THEN 0 ELSE 1 END,
			LENGTH(taxa_formula) DESC,
			taxa_formula
	) LOOP
		l_pattern := MCZBASE.TAXA_FORMULA_PATTERN(f.taxa_formula);
		IF REGEXP_LIKE(p_taxon_name, l_pattern) THEN
			l_two_taxa := REGEXP_LIKE(f.taxa_formula, '(^| )B( |$)');
			l_separator := SUBSTR(f.taxa_formula, 2, LENGTH(f.taxa_formula) - 2);
			IF l_two_taxa AND f.taxa_formula LIKE 'A %' AND f.taxa_formula LIKE '% B'
					AND INSTR(l_separator, '{string}') = 0 THEN
				-- A <separator> B: try the separator at each place it occurs
				l_occurrence := 1;
				LOOP
					l_position := INSTR(p_taxon_name, l_separator, 1, l_occurrence);
					EXIT WHEN l_position = 0 OR l_done;
					l_one := TRIM(SUBSTR(p_taxon_name, 1, l_position - 1));
					l_two := TRIM(SUBSTR(p_taxon_name, l_position + LENGTH(l_separator)));
					IF l_one IS NOT NULL AND l_two IS NOT NULL THEN
						consider(f.taxa_formula, l_one, l_two);
					END IF;
					l_occurrence := l_occurrence + 1;
				END LOOP;
			ELSE
				-- any other shape of formula: the one reading its regular expression gives
				l_one := TRIM(REGEXP_SUBSTR(p_taxon_name, l_pattern, 1, 1, NULL, 1));
				l_two := NULL;
				IF l_two_taxa THEN
					l_two := TRIM(REGEXP_SUBSTR(p_taxon_name, l_pattern, 1, 1, NULL, 2));
				END IF;
				consider(f.taxa_formula, l_one, l_two);
			END IF;
		END IF;
		EXIT WHEN l_done;
	END LOOP;
END;
