REM INSERTING into CTBORROW_STATUS
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTBORROW_STATUS (BORROW_STATUS) values ('open');
Insert into CTBORROW_STATUS (BORROW_STATUS) values ('partially returned');
Insert into CTBORROW_STATUS (BORROW_STATUS) values ('returned');
