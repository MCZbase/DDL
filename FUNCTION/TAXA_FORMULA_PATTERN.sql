
  CREATE OR REPLACE EDITIONABLE FUNCTION "TAXA_FORMULA_PATTERN" (
	p_taxa_formula IN VARCHAR2
) RETURN VARCHAR2 DETERMINISTIC IS
	-- Returns the anchored regular expression that a taxon name written in the form of a taxa
	-- formula from MCZBASE.CTTAXA_FORMULA matches.  The tokens A and B stand for taxon names,
	-- {string} for free text in braces, and everything else in the formula is matched literally
	-- and case sensitively, so
	--     'A sp. ?'  ->  ^(.+?) sp\. \?$
	--     'A nr. B'  ->  ^(.+?) nr\. (.+)$
	-- A is matched lazily, so where a two taxon separator occurs more than once the first
	-- subexpression ends at its first occurrence.  Subexpression 1 is A and 2 is B.
	-- Usable in SQL, e.g. REGEXP_LIKE(name, MCZBASE.TAXA_FORMULA_PATTERN(taxa_formula)).
	-- @param p_taxa_formula a value of MCZBASE.CTTAXA_FORMULA.TAXA_FORMULA.
	-- @return the regular expression.
	-- @see MCZBASE.PARSE_TAXA_FORMULA
	l_pattern VARCHAR2(4000);
BEGIN
	-- escape regular expression metacharacters, then put back the A, B and {string} tokens
	l_pattern := REPLACE(p_taxa_formula, '\', '\\');
	l_pattern := REPLACE(l_pattern, '.', '\.');
	l_pattern := REPLACE(l_pattern, '?', '\?');
	l_pattern := REPLACE(l_pattern, '*', '\*');
	l_pattern := REPLACE(l_pattern, '+', '\+');
	l_pattern := REPLACE(l_pattern, '^', '\^');
	l_pattern := REPLACE(l_pattern, '$', '\$');
	l_pattern := REPLACE(l_pattern, '|', '\|');
	l_pattern := REPLACE(l_pattern, '(', '\(');
	l_pattern := REPLACE(l_pattern, ')', '\)');
	l_pattern := REPLACE(l_pattern, '[', '\[');
	l_pattern := REPLACE(l_pattern, ']', '\]');
	l_pattern := REPLACE(l_pattern, '{', '\{');
	l_pattern := REPLACE(l_pattern, '}', '\}');
	l_pattern := REPLACE(l_pattern, '\{string\}', '\{.*\}');
	l_pattern := REGEXP_REPLACE(l_pattern, '(^| )A( |$)', '\1(.+?)\2');
	l_pattern := REGEXP_REPLACE(l_pattern, '(^| )B( |$)', '\1(.+)\2');
	RETURN '^' || l_pattern || '$';
END;
