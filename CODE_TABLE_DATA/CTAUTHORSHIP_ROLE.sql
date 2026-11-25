REM INSERTING into CTAUTHORSHIP_ROLE
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTAUTHORSHIP_ROLE (AUTHORSHIP_ROLE,ORDINAL,NOMENCLATURAL_CODE,DESCRIPTION) values ('zoological author',0,'ICZN','An author of a zoological name');
Insert into CTAUTHORSHIP_ROLE (AUTHORSHIP_ROLE,ORDINAL,NOMENCLATURAL_CODE,DESCRIPTION) values ('zoological in author',1,'ICZN','An author of a work in which a zoological name was created that is credited in the authorship string, for cases such as the author of a paper when a single species description in that paper is credited to another author, for example ''Smith'' in the authorship string ''Jones in Smith, 1880''');
