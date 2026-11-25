REM INSERTING into CTLOAN_STATUS
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTLOAN_STATUS (LOAN_STATUS) values ('closed');
Insert into CTLOAN_STATUS (LOAN_STATUS) values ('in process');
Insert into CTLOAN_STATUS (LOAN_STATUS) values ('open');
Insert into CTLOAN_STATUS (LOAN_STATUS) values ('open historical');
Insert into CTLOAN_STATUS (LOAN_STATUS) values ('open in-house');
Insert into CTLOAN_STATUS (LOAN_STATUS) values ('open partially returned');
Insert into CTLOAN_STATUS (LOAN_STATUS) values ('open under-review');
