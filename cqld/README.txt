This file will describe the steps necessary to load CQLD data into Virtuoso

All scripts should be found in the hhsScripts directory

1) Make sure the config.bash file is properly configured for your installation.
    cd $VIRTUOSO_HOME/hhsScripts
    vi config.bash

2) If the Virtuoso server is running, kill -9 it:
    cd $VIRTUOSO_HOME/bin
    ps -ef | grep "irtuoso"
    sudo kill -9 XXXXX    (where XXXXX is the process number)

3) go to the database directory and remove/move-away files virtuoso.lck, virtuoso.db, virtuoso.trx  This blows away the current Virtuoso data.
    cd $VIRTUOSO_HOME/db      (actual location may vary depending on installation)
    sudo rm virtuoso.lck virtuoso.db virtuoso.trx

4) delete files in the vsp/hhsFileSystem directory. This removes the old RDF data.
    cd $VIRTUOSO_HOME/vsp/hhsFileSystem
    rm -fR *

5) Convert the dataset filenames to use the correct date format. This step may not be necessary at some point in the future. If we can get the powers that be to generate proper dates in the filenames, this step should go away. But for the mean time...
    cd $VIRTUOSO_HOME/hhsScripts
    ./patchBadDates /home/whoever/datasets/20110523 

6) I often gather together all of the datasets and ontologies into a deploytree. 
    cd  /home/whoever/datasets
    mkdir deploytree
    cd /home/whoever/datasets/20110523
    cp -fR patched /home/whoever/datasets/deploytree/20110523
    cd /home/whoever/datasets/20110916
    cp -fR patched /home/whoever/datasets/deploytree/20110916
    ...
    cd /home/whoever/ontologies
    mkdir  /home/whoever/datasets/deploytree/ontologies
    cp *  /home/whoever/datasets/deploytree/ontologies
   

7) execute the prepDatasets script, it will create the proper directory structure in vsp/hhsFileSystem. you can this multiple times, if you are pulling data from multiple trees.
    cd $VIRTUOSO_HOME/hhsScripts
    ./prepDatasets /home/whoever/datasets/deploytree  
    
8) Start the virtuoso server. 

9) change the password of the virtuoso server, so that it matches the password in the config.bash script

10) Load the latest facet and iSparql modules in conductor. You can versions of those files that are known to work in the $VIRTUOSO_HOME/hhsScripts/vad directory
    
11) Load the iSparql scripts into webdav from hhsScripts/DAV/home/dav/sparql_demo_queries. In the directory: DAV/home/dav/sparql_demo_queries   upload the following files:

All_Measure30_Records_For_DC_Hospitals.isparql
DC_CAC_Name_Address_State_Tel.isparql
DC_Hospitals_Admissions_Percentage_WorseThanUSNationalRate_30DayReadmissionRate.isparql
Percentage_of_Admissions_values_from_Records_of_DC_Hospitals_having_ThirtyDayReadmissionRates_WorseThanUSNationalRate.isparql
_of_Adm_Records_DC_Hosp_30DayRead_WorseThanUSNational.isparql
dc_cac_hospitals.isparql
second_try.isparql

12) Copy/update the following files from the hhsScripts/VAD (and its children directories) into webdav. These files can be found in $VIRTUOSO_HOME/hhsScripts/VAD/....  This should cause the changes to the default look and feel of Virtuoso:

VAD/fct/facet.vsp
VAD/fct/facet_doc.html
VAD/fct/facet_view.sql
VAD/fct/images/cms_logo.png
VAD/fct/images/logo_health.png
VAD/fct/rdfdesc/description.vsp
VAD/fct/rdfdesc/settings.vsp
VAD/fct/rdfdesc/styles/default.css  copy this one to VAD/fct/styles/default.css as well
VAD/fct/rdfdesc/usage.vsp

13) Load facet_view.sql directly in the iSQL console

14) Load the rewrite rules, hhsRewriter.sql directly in the iSQL console

15) Using the Virtuoso conductor interface, upload all of the namespaces as found in the cqld.rdfs file

16) Execute the loadGraphs script.  This script will: Load RDF graphs, Generate void metadata as turtle files, Load turtle files (void metadata), Update all of the various caches in Virtuoso, so that search will work properly.
    cd $VIRTUOSO_HOME/hhsScripts
    ./loadGraphs


