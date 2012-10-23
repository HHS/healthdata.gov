#!/bin/bash

######################################################################
# Forward unto Tomcat that which is Tomcat's
#
# This file contains symbolic links that point to a shadow tree rooted in this directory.
# This directory, apache-ajp, is a shadow root created to be a persistent location for an application.
#
# Symbolic links added on date:      Wed Oct 17 14:37:25 EDT 2012
# Symbolic links added via script /apps/scripts/moveToPermHome.sh
######################################################################

ln -f -s /apps/apache-ajp/root/etc/httpd/conf.d/proxy_ajp.conf /etc/httpd/conf.d

#
# You may need the following line, if Apache loads before this script is run
#
/usr/sbin/apachectl -k graceful

