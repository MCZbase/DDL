REM INSERTING into CTMEDIA_LABEL
SET DEFINE OFF;
SET SQLBLANKLINES ON;
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('ac:resourceCreationTechnique','Use "Sequential Section Scan" for scans of serial sections to be linked from Morphosource.  For general use, follow the Audubon Core Definition:  	Information about technical aspects of the creation and digitization process of the resource. This includes modification steps ("retouching") after the initial resource capture.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('aspect','Specific orientation, direction, or view angle of the subject represented in the media resource with respect to the acquisition device.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('credit','Credit/attribution as designated by the copyright owner.  You must use include this label for all media that are not owned by Harvard and are under a creative commons license.  If used with Museum of Comparative Zoology media, will be added to the auto-generated credit line.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('dcterms:identifier','A resolvable or non resolvable unique identifier for the media object.  This may be a UUID, an ARK, a DOI, etc.
See: https://tdwg.github.io/ac/termlist/#dcterms_identifier');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('description','Human readable description of media object, containing the Who, What, When, Where and Why as free-form text.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('height','Display height of media object, in pixels');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('internal remarks','used for remarks limited to internal staff use.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('light source','Description of how the subject of an image was illuminated.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('made date','The date on which the media object was created, must be in the form yyyy-mm-dd');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('md5hash','MD5 Checksum of media file.  Automatically generated');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('original filename',null);
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('owner','Copyright owner for the media.  Automatically shown for media marked as owned by the MCZ.  Must be added for any non-MCZ media that are available under a creative commons license.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('remarks','Remarks about the media object that can be exposed to the public.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('size per pixel (μm)','A value in micrometers (μm) that represents the size scale of each pixel in an image. Often determined by the instrument (such as micro-CT scanner) or process, and works best in combination with a scale bar in the image.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('spectrometer','If the media object is the output of a spectrometer, the model of spectrometer used to create the media object.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('spectrometer reading location','If the media object is the output of a spectrometer, where on the subject was the spectrometer reading taken.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('subject','A description of what the media object is of, similar to the What portion of the description.');
Insert into CTMEDIA_LABEL (MEDIA_LABEL,DESCRIPTION) values ('width','Display width of media object, in pixels.');
