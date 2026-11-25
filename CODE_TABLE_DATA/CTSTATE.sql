REM INSERTING into CTSTATE
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTSTATE (STATE,DESCRIPTION,STATE_CURIE) values ('Approved','The proposed interpretation or requested action has been accepted for implementation or follow-up.','oslc_cm:Approved');
Insert into CTSTATE (STATE,DESCRIPTION,STATE_CURIE) values ('Closed','Work on the annotation report is complete and the issue is closed.','oslc_cm:Closed');
Insert into CTSTATE (STATE,DESCRIPTION,STATE_CURIE) values ('In Progress','Work is actively underway to evaluate or address the reported issue.','oslc_cm:In-progress');
Insert into CTSTATE (STATE,DESCRIPTION,STATE_CURIE) values ('New','Newly created annotation report; not yet reviewed or triaged.',null);
