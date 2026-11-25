REM INSERTING into CTLOAN_TYPE
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTLOAN_TYPE (LOAN_TYPE,SCOPE,ORDINAL) values ('consumable','Loan',2);
Insert into CTLOAN_TYPE (LOAN_TYPE,SCOPE,ORDINAL) values ('exhibition-master','Loan',3);
Insert into CTLOAN_TYPE (LOAN_TYPE,SCOPE,ORDINAL) values ('exhibition-subloan','Loan',3);
Insert into CTLOAN_TYPE (LOAN_TYPE,SCOPE,ORDINAL) values ('returnable','Loan',1);
