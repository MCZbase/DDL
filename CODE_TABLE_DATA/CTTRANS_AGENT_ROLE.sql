REM INSERTING into CTTRANS_AGENT_ROLE
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('additional in-house contact','MCZ agent, in addition to the internal contact, who should be included in correspondence concerning the transaction');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('additional outside contact','External agent, in addition to the outside contact, who should be included in correspondence concerning the transaction.');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('borrow overseen by','MCZ agent authorizing and responsible for a borrow');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('entered by','MCZ agent who created the transaction (automatically recorded)');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('for use by','Agent that uses the material but is not the official recipient (e.g., graduate student, visiting researcher) [Note: designation for accessions of material to be used by the HMNH only and will not be cataloged in an MCZ Collection; option is selected on the Create Accession screen.]');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('in-house authorized by','MCZ departmental agent authorizing a transaction (e.g., Curator, Curatorial Associate); may be the same as the "in-house contact" ');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('in-house contact','MCZ departmental agent responsible for activities associated with the transaction (e.g., MCZ curatorial associate for departmental transactions, Collections Ops representative for Special Collections)');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('lending institution','Outside institution providing borrowed material to the MCZ; in the case of an internal borrow, MCZ department providing borrowed material to another department');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('outside authorized by','External agent who authorized the transaction (for accessions, external agent who authorized the transfer of ownership to the MCZ).');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('outside contact','Outside agent who is the primary contact for a transaction');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('received by','Agent receiving the material involved in a transaction');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('received from','Institution or agent transferring the material to the MCZ; in the case of an internal borrow, MCZ department providing borrowed material to another department ');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('recipient institution','Institution to which a loan or deaccession has been made. [Note: loans and deaccessions are made institution to institution.]');
Insert into CTTRANS_AGENT_ROLE (TRANS_AGENT_ROLE,DESCRIPTION) values ('stewardship from agency','Only for accessions, which is under stewardship from an outside agency');
