REM INSERTING into CTLOAN_ITEM_STATE
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('consumed','Consumable item has been consumed as part of this loan.  Use deaccessoned - used up for items in a returnable loan that were expected to be returned but which were consumed.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('deaccessioned - discarded','Item that was not expected to be consumed has been discarded from a returnable loan without being returned.  A deaccession should exist recording the deaccessioning of this item.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('deaccessioned - exchanged','Item was exchanged while on loan without being returned.  A deaccession should exist recording the deaccessioning of this item.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('deaccessioned - gift','Item was gifted while on loan without being returned.  A deaccession should exist recording the deaccessioning of this item.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('deaccessioned - other','Item was deaccessioned while on loan without being returned for some reason not covered by the other deaccession states.  A deaccession should exist recording the deaccessioning of this item.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('deaccessioned - repatriated','Item was repatriated while on loan without being returned.  A deaccession should exist recording the deaccessioning of this item.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('deaccessioned - transfer','Item was transferred to another institution while on loan without being returned.  A deaccession should exist recording the deaccessioning of this item.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('deaccessioned - used up','Item that was expected to be returned, but which was consumed in a loan without being returned.  A deaccession should exist recording the deaccessioning of this item.   Use consumed to note items in a consumable loan that were not expected to be returned.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('in loan','Item has been added to the loan, and is either in preparation or has been sent on loan, but not returned or consumed.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('missing','Item went missing, or was lost, or was destroyed as part of this loan.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('returned','Item has been returned from this loan.');
Insert into CTLOAN_ITEM_STATE (LOAN_ITEM_STATE,DESCRIPTION) values ('unknown','Legacy value for material where state is not known');
