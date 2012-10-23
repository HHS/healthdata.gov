#!/bin/bash
#
# All HHS scripts use this file 
#

##############################
# SCRIPT_DIR 
##############################
# SCRIPT_DIR="/Applications/OpenLinkVirtuoso/Virtuoso6.2/hhsSesameScripts"

SCRIPT_DIR="/home/ubuntu/cqld/hhsSesameScripts"

##############################
#  STAGING_DIR
##############################
# STAGING_DIR="/Applications/OpenLinkVirtuoso/Virtuoso6.2/vsp/hhsFileSystem"

STAGING_DIR="/tmp/hhsFileSystem"

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

