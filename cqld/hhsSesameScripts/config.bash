#!/bin/bash
#
# All HHS scripts use this file 
#
##############################
# ISQL_PORT is the port used for this instance of Virtuoso for the isql command
##############################
# ISQL_PORT="1111"

ISQL_PORT="1111"

##############################
# ISQL_USER is the username to administer this instance of Virtuoso
##############################
# ISQL_USER="dba"

ISQL_USER="dba"

##############################
# ISQL_PASSWORD is the password for $ISQL_USER to administer this instance of Virtuoso
##############################
# ISQL_PASSWORD="dba"

ISQL_PASSWORD="dba"

##############################
# VIRTUOSO_HOME 
##############################
# VIRTUOSO_HOME="/usr2/local/virtuoso-6.1.3"

VIRTUOSO_HOME="/Applications/OpenLinkVirtuoso/Virtuoso6.2"

##############################
# ISQL_CMD is the command used for this instance of Virtuoso 
##############################
# ISQL_CMD="/u02/virtuoso/bin/isql"

ISQL_CMD="${VIRTUOSO_HOME}/bin/isql"

##############################
# HHS_SCRIPT is the directory that contains all of the HHS scripts
##############################
# HHS_SCRIPT="${VIRTUOSO_HOME}/hhsScript"

HHS_SCRIPT="${VIRTUOSO_HOME}/hhsScript"

##############################
# HHS_BACKUP is the location to store/retrieve backup zip files
##############################
# HHS_BACKUP="${VIRTUOSO_HOME}/hhsBackupStorage"

HHS_BACKUP="${VIRTUOSO_HOME}/hhsBackupStorage"


##############################
# SPARQL_ENDPOINT is the URL of sparql endpoint, used by curl and such...
##############################
# SPARQL_ENDPOINT="http://localhost:80/sparql"

SPARQL_ENDPOINT="http://localhost:80/sparql"

##############################
# ALT_HOST is the host name and port to use instead of the 
#   default host names: 
#      http://healthdata.gov or 
#      http://reference.data.gov
#
# Leave this variable blank to get the default host names
##############################
# ALT_HOST=
# ALT_HOST="http://socialdataweb.org:8890"

ALT_HOST=

