REM INSERTING into CTMOTIVATION
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('classifying','The motivation for when the user intends to classify the Target as something. For example to classify an image as a portrait.');
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('commenting','The motivation for when the user intends to comment about the Target. For example to provide a commentary about a particular PDF document.');
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('describing','The motivation for when the user intends to describe the Target, as opposed to a comment about them.');
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('editing','The motivation for when the user intends to request a change or edit to the Target resource. For example an Annotation that requests a typo to be corrected. ');
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('identifying','The motivation for when the user intends to assign an identity to the Target or identify what is being depicted or described in the Target.');
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('linking','The motivation for when the user intends to link to a resource related to the Target.');
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('qualityAssessment','W3C Data Quality Vocabulary, dqv:qualityAssessment "Motivation that must be specified for quality annotations."  Narrower than oa:assessing.');
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('questioning','The motivation for when the user intends to ask a question about the Target. For example to ask for assistance with a particular section of text, or question its veracity.');
Insert into CTMOTIVATION (MOTIVATION,DESCRIPTION) values ('replying','The motivation for when the user intends to reply to a previous statement, either an Annotation or another resource. ');
