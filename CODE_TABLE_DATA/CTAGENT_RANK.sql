REM INSERTING into CTAGENT_RANK
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTAGENT_RANK (AGENT_RANK,DESCRIPTION) values ('B','Does not respond to automated loan notification; responds if contacted personally');
Insert into CTAGENT_RANK (AGENT_RANK,DESCRIPTION) values ('C','Loans past due; Agent has previously been in contact but no response in over a year');
Insert into CTAGENT_RANK (AGENT_RANK,DESCRIPTION) values ('D','Loans past due for multiple years; Does not respond when contacted by any means');
Insert into CTAGENT_RANK (AGENT_RANK,DESCRIPTION) values ('F','Director has become involved due to overdue loans');
