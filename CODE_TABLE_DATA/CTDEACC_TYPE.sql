REM INSERTING into CTDEACC_TYPE
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTDEACC_TYPE (DEACC_TYPE,DESCRIPTION) values ('discarded','Material discarded after careful consideration has determined that there is no possible further use for it, which should only be done rarely and with curatorial approval. (Transaction closed upon discard)');
Insert into CTDEACC_TYPE (DEACC_TYPE,DESCRIPTION) values ('exchange','Material sent to another institution to be accessioned there, with material also being sent to the MCZ to be accessioned here in exchange. (Closed upon receipt of signed paperwork and specimens)');
Insert into CTDEACC_TYPE (DEACC_TYPE,DESCRIPTION) values ('gift','Material consisting of specimens being donated to another institution to be recataloged and placed in their collection. (Closed upon receipt of signed paperwork)');
Insert into CTDEACC_TYPE (DEACC_TYPE,DESCRIPTION) values ('other','For rare special cases that address unique situations, which can only be set for use by MCZ Collections Operations.');
Insert into CTDEACC_TYPE (DEACC_TYPE,DESCRIPTION) values ('repatriated','Material which has been returned to its community or country of origin (via NAGPRA or voluntary repatriation).');
Insert into CTDEACC_TYPE (DEACC_TYPE,DESCRIPTION) values ('transfer','Material consisting of objects which are not specimens being permanently sent to another institution, and can only be made from the “MCZ Collections” collection on behalf of the MCZ.');
Insert into CTDEACC_TYPE (DEACC_TYPE,DESCRIPTION) values ('transfer (internal)','Material consisting of objects which are transferred within MCZ from one department to another.');
Insert into CTDEACC_TYPE (DEACC_TYPE,DESCRIPTION) values ('used up','Material used up while out on a consumable loan. (Transaction closed upon completion of deaccession record in MCZbase)');
