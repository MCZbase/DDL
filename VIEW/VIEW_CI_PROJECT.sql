
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_CI_PROJECT" ("COLLECTION_OBJECT_ID", "PROJECT_ID", "PROJECT_NAME", "PROJECT_DESCRIPTION", "PROJECT_REMARKS", "MASK_PROJECT_FG", "PROJECT_AGENT_ID", "PROJECT_AGENT_NAME", "PROJECT_AGENT_ROLE", "PUBLICATION_ID", "PROJECT_PUBLICATION_CITATION") AS 
  SELECT DISTINCT
    ci.collection_object_id,
    p.project_id,
    p.project_name,
    p.project_description,
    p.project_remarks,
    p.mask_project_fg,

    pa_ag.agent_id          AS project_agent_id,
    pa_an.agent_name        AS project_agent_name,
    'project agent'         AS project_agent_role,

    pub.publication_id,
    fp_long.formatted_publication AS project_publication_citation

FROM cataloged_item ci
JOIN accn a
  ON a.transaction_id = ci.accn_id
JOIN project_trans pt_accn
  ON pt_accn.transaction_id = a.transaction_id
JOIN project p
  ON p.project_id = pt_accn.project_id

LEFT JOIN project_agent pa
  ON pa.project_id = p.project_id
LEFT JOIN agent_name pa_an
  ON pa_an.agent_name_id = pa.agent_name_id
LEFT JOIN agent pa_ag
  ON pa_ag.agent_id = pa_an.agent_id

LEFT JOIN project_publication pp
  ON pp.project_id = p.project_id
LEFT JOIN publication pub
  ON pub.publication_id = pp.publication_id
LEFT JOIN formatted_publication fp_long
  ON fp_long.publication_id = pub.publication_id
 AND fp_long.format_style   = 'long'

UNION ALL

/* 2. ACCESSION-BASED PROJECT SPONSORS */
SELECT DISTINCT
    ci.collection_object_id,
    p.project_id,
    p.project_name,
    p.project_description,
    p.project_remarks,
    p.mask_project_fg,

    ps_ag.agent_id          AS project_agent_id,
    ps_an.agent_name        AS project_agent_name,
    'project sponsor'       AS project_agent_role,

    pub.publication_id,
    fp_long.formatted_publication AS project_publication_citation

FROM cataloged_item ci
JOIN accn a
  ON a.transaction_id = ci.accn_id
JOIN project_trans pt_accn
  ON pt_accn.transaction_id = a.transaction_id
JOIN project p
  ON p.project_id = pt_accn.project_id

LEFT JOIN project_sponsor ps
  ON ps.project_id = p.project_id
LEFT JOIN agent_name ps_an
  ON ps_an.agent_name_id = ps.agent_name_id
LEFT JOIN agent ps_ag
  ON ps_ag.agent_id = ps_an.agent_id

LEFT JOIN project_publication pp
  ON pp.project_id = p.project_id
LEFT JOIN publication pub
  ON pub.publication_id = pp.publication_id
LEFT JOIN formatted_publication fp_long
  ON fp_long.publication_id = pub.publication_id
 AND fp_long.format_style   = 'long'

UNION ALL

/* 3. LOAN-BASED PROJECT AGENTS */
SELECT DISTINCT
    ci.collection_object_id,
    p.project_id,
    p.project_name,
    p.project_description,
    p.project_remarks,
    p.mask_project_fg,

    pa_ag.agent_id          AS project_agent_id,
    pa_an.agent_name        AS project_agent_name,
    'project agent'         AS project_agent_role,

    pub.publication_id,
    fp_long.formatted_publication AS project_publication_citation

FROM cataloged_item ci
JOIN specimen_part sp
  ON sp.derived_from_cat_item = ci.collection_object_id
JOIN loan_item li
  ON li.collection_object_id = sp.collection_object_id
JOIN loan l
  ON l.transaction_id = li.transaction_id
JOIN project_trans pt_loan
  ON pt_loan.transaction_id = l.transaction_id
JOIN project p
  ON p.project_id = pt_loan.project_id

LEFT JOIN project_agent pa
  ON pa.project_id = p.project_id
LEFT JOIN agent_name pa_an
  ON pa_an.agent_name_id = pa.agent_name_id
LEFT JOIN agent pa_ag
  ON pa_ag.agent_id = pa_an.agent_id

LEFT JOIN project_publication pp
  ON pp.project_id = p.project_id
LEFT JOIN publication pub
  ON pub.publication_id = pp.publication_id
LEFT JOIN formatted_publication fp_long
  ON fp_long.publication_id = pub.publication_id
 AND fp_long.format_style   = 'long'

UNION ALL

/* 4. LOAN-BASED PROJECT SPONSORS */
SELECT DISTINCT
    ci.collection_object_id,
    p.project_id,
    p.project_name,
    p.project_description,
    p.project_remarks,
    p.mask_project_fg,

    ps_ag.agent_id          AS project_agent_id,
    ps_an.agent_name        AS project_agent_name,
    'project sponsor'       AS project_agent_role,

    pub.publication_id,
    fp_long.formatted_publication AS project_publication_citation

FROM cataloged_item ci
JOIN specimen_part sp
  ON sp.derived_from_cat_item = ci.collection_object_id
JOIN loan_item li
  ON li.collection_object_id = sp.collection_object_id
JOIN loan l
  ON l.transaction_id = li.transaction_id
JOIN project_trans pt_loan
  ON pt_loan.transaction_id = l.transaction_id
JOIN project p
  ON p.project_id = pt_loan.project_id

LEFT JOIN project_sponsor ps
  ON ps.project_id = p.project_id
LEFT JOIN agent_name ps_an
  ON ps_an.agent_name_id = ps.agent_name_id
LEFT JOIN agent ps_ag
  ON ps_ag.agent_id = ps_an.agent_id

LEFT JOIN project_publication pp
  ON pp.project_id = p.project_id
LEFT JOIN publication pub
  ON pub.publication_id = pp.publication_id
LEFT JOIN formatted_publication fp_long
  ON fp_long.publication_id = pub.publication_id
 AND fp_long.format_style   = 'long'