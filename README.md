# DDL
Build Scripts for all Database Objects in MCZbase

[![DOI](https://zenodo.org/badge/144744182.svg)](https://zenodo.org/badge/latestdoi/144744182)

## To update

Generate new export by dumping from MCZbase database with:

    BEGIN
       MCZBASE.GENERATE_DDL();
    END;
    /

Then use this export to update files in checkout of this DDL project.
