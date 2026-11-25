REM INSERTING into CTTAXON_RELATION
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTTAXON_RELATION (TAXON_RELATIONSHIP,DESCRIPTION,INVERSE_RELATION) values ('accepted synonym of',null,'synonym of');
Insert into CTTAXON_RELATION (TAXON_RELATIONSHIP,DESCRIPTION,INVERSE_RELATION) values ('junior homonym of',null,'senior homonym of');
Insert into CTTAXON_RELATION (TAXON_RELATIONSHIP,DESCRIPTION,INVERSE_RELATION) values ('nomen oblitum of','This relationship points is applied to the a nomen oblitum and relates it to its nomen protectum.  ICZN Glossary "nomen oblitum: A Latin term (meaning "forgotten name") applied after 1 January 2000 to a name, unused since 1899, which as a result of an action taken under Article 23.9.2 does not take precedence over a younger synonym or homonym in prevailing usage; the younger name which takes precedence over the nomen oblitum may be called a nomen protectum (q.v.). The term nomen oblitum was also applied to a disused senior synonym rejected between 6 November 1961 and 1 January 1973 under Article 23b of the Code editions then in force (see Article 23.12.2). Nomina oblita remain available names; see Articles 23.9 and 23.12 for conditions controlling their use as valid names."','nomen protectum of');
Insert into CTTAXON_RELATION (TAXON_RELATIONSHIP,DESCRIPTION,INVERSE_RELATION) values ('replacement name for',null,'replaced by');
Insert into CTTAXON_RELATION (TAXON_RELATIONSHIP,DESCRIPTION,INVERSE_RELATION) values ('synonym of',null,'accepted synonym of');
