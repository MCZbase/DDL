REM INSERTING into CTTAXON_STATUS
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTTAXON_STATUS (TAXON_STATUS,DESCRIPTION) values ('unavailable name','A scientific name that does not conform to Articles 10 to 20, or that is an excluded name under Article 1.3 of the ICZN.  Nomina nuda and manuscript names are subsets of unavailable names.  ');
Insert into CTTAXON_STATUS (TAXON_STATUS,DESCRIPTION) values ('unavailable: manuscript name','An unavailable name resulting from an unpublished work.  A name which does not meet the publication requirements for avaiability of ICZN ARticle 11.1.  Also include the MS status in the authorship string for the name.');
Insert into CTTAXON_STATUS (TAXON_STATUS,DESCRIPTION) values ('unavailable: nomen nudum','A name that is unavailable because it was published without an adequate description, that is, a name published without meeting the requirements for availability related to the presence of a description or indication for the name as specified in Article 12 or Article 13 of the ICZN

ICZN Glossary: "A Latin term referring to a name that, if published before 1931, fails to conform to Article 12; or, if published after 1930, fails to conform to Article 13. A nomen nudum is not an available name, and therefore the same name may be made available later for the same or a different concept; in such a case it would take authorship and date [Arts. 50, 21] from that act of establishment, not from any earlier publication as a nomen nudum.".');
