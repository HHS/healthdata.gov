#!/bin/bash

# File:   /apps/scripts/moveToPermHome.sh
#

if [ $# -lt "3" ]; then
   echo "Usage: "
   echo " /apps/scripts/moveToPermHome.sh  <fileOfThings> <appName> [<comment>] [-u]"
   echo "   Where:"
   echo "      <fileOfThings> is a file of things to move; one fully qualified thing per line."
   echo "               A thing can be a file or a directory."
   echo "      <appName> will create /apps/<appName>/root to be a copy of the unix root,"
   echo "                with only those things moved."
   echo "      <comment> is the comment you want as part of a header in /apps/<appName>/root/config.sh"
   echo "      -u        specifies that you want to undo the symbolic links and move"
   echo "                the files back to their original location."
   echo "" 
   echo "Sample Usage, move links into the /apps/virtuoso directory:"
   echo " sudo /apps/scripts/moveToPermHome.sh  /tmp/moveItems  virtuoso  \"Links for Virtuoso\" " 
   echo ""
   echo "Another Sample Usage, remove symbolic links and move files back to their original location:"
   echo " sudo /apps/scripts/moveToPermHome.sh  /apps/virtuoso/root/moveItemsList.txt  virtuoso  -u" 
   exit 1
fi

#
# Original Author: Doug Whitehead
# Original Creation Date: 8/20/2012
#
# This is meant as a script to help one who installs applications
# to move from their default locations to a new, more persistent mount point.
#
# This script will copy a list of files or directories to some persistent place.
# This will create a shadow root (e.g. /apps/virtuoso) that only contains
# the files or directories moved. Then this script will create symbolic links 
# from the original location to the persistent place.
# Lastly, the symbolic link will be appended to the /tmp/setup.sh.extras

# Advantages of the approach used by this script and its methodology is that it: 
#   1) makes re-homing consistent 
#   2) clusters all app specific stuff in an app specific root (in /apps/virtuoso, in the example above)
#
# The file (e.g. /apps/virtuoso/config.sh) will be appended with the symbolic links.
# Source this file from /apps/config.sh to ensure that the symbolic links 
# will be re-established on a restart of the Amazon EC2 virtual machine.


############################################################
#  ######################################################  #
#  #             Step By Step Usage Example             #  #
#  ######################################################  #
############################################################


#########  Step 1: Use the Amazon EC2 manager to take a snpshot of your running instance  ########
#
# If you screw things up, you'll be glad you can go back to here.
#


#########  Step 2: Create the move items list ########
#
# You need to create a text file that has one item to move on each line.
# For example, following might find all files or directories that have "irtuoso" in them.
#
#     $  find / -name "*irtuoso*" 2>&1 | grep -v "ermission" >/tmp/moveItems

# Notes about the above commandline:
#    * The above "find" will not locate objects that the user does not have permission to read.
#    * The "find" finds files based on a pattern and pipes errors into the output stream
#    * The "grep" filters out permission errors
#    * Whatever drops out of the pipe is sent to the file /tmp/moveItems


# After creating the move items list, one should inspect/edit it.

#########  Step 3: Edit the move items list, to add/remove entries  ########
#
#     $  vi /tmp/moveItems
#   
# In your invocation script, make sure to:
#   Delete lines for files (or directories) that you don't want to move.
#   Add any additional files (or directories) that you want to move (no trailing slash, please)


# Assuming you are comfortable with your move items list, you can run this script:

#########  Step 4: invoke this script  ########
#
#    $  sudo /apps/scripts/moveToPermHome.sh  /tmp/moveItems  /apps/virtuoso  "Links for Virtuoso"


#########  Step 5: Add symbolic links to /apps/config.sh  ########
#
#    $  sudo echo "source /apps/virtuoso/config.sh" >>/apps/config.sh
 

#########  Bonus Step: Order a beer, you are done!  ########
#
#


######################################################################
#  ################################################################  #
#  #         The script  /apps/scripts/moveToPermHome.sh          #  #
#  ################################################################  #
######################################################################

#
#  moveit: Move a single file to a permanent location, and create a link to it
#          from its original location (to its new location).
#
#            This function will be invoked once for each item in the moveItemsList.txt file
#
function moveit {
   echo "Moving from transient directory: $1 to persistent directory: $2, filename: $3"
#            If the persistent directory doesn't exist, create it (and potentially all of its parent directories)
   mkdir -p $2
#            Move the original file to the persistent directory
   mv $1/$3 $2
#            Create a symbolic link at the original file location pointing to the file in the persistent directory
   ln -s $2/$3 $1
#            Append the symbolic link to config.sh
   echo "ln -f -s $2/$3 $1" >>$4
}

#
#  unmoveit: Remove a symbolic link and restore a file to its original location
#
#            This function will be invoked once for each item in the moveItemsList.txt file
#
function unmoveit {
#            Only if the symbolic link exists in its original location
   if [ -L $1/$3 ]; then
      echo "Restoring $3 from directory: $2 back to the original directory: $1"
#            Remove the symbolic link
      rm $1/$3
#            Move the file back to its original location
      mv $2/$3 $1
   else 
      echo "Failure to restore $3 to $1, as no symbolic link found"
   fi
}


persistRoot=/apps/$2/root

#
#            If the user specified to "undo" symbolic links
#
if [ "$3" = "-u" ]; then
#            Loop through the list
   for f in `cat $1` ; do
      origPath=`echo "$f" | sed "s/^\(.*\)\/\([^/]*\)/\1/g"`
      shortName=`echo "$f" | sed "s/^\(.*\)\/\([^/]*\)/\2/g"`
      unmoveit $origPath ${persistRoot}${origPath} $shortName
   done
   echo "**************************************************************************"
   echo "**** Warning - config.sh and moveItemsList.txt have NOT been modified,"
   echo "****   so these files no longer accurately reflect what is in $persistRoot"
   echo "**************************************************************************"
   exit 0
fi


#
#            Create the desired directory, if it doesn't already exist.
#
mkdir -p $persistRoot

#
#            Append the move items to the move item list file.
#
cat $1 >>${persistRoot}/moveItemsList.txt

#
#            Append a header for the links added by this script recorded in the application's config.sh
#
echo "#!/bin/bash" >>${persistRoot}/config.sh
echo "" >>${persistRoot}/config.sh
echo "######################################################################" >>${persistRoot}/config.sh
echo "# $3" >>${persistRoot}/config.sh
echo "#" >>${persistRoot}/config.sh
echo "# This file contains symbolic links that point to a shadow tree rooted in this directory." >>${persistRoot}/config.sh
echo "# This directory, $2, is a shadow root created to be a persistent location for an application." >>${persistRoot}/config.sh
echo "#" >>${persistRoot}/config.sh
echo "# Symbolic links added on date:      `date`" >>${persistRoot}/config.sh
echo "# Symbolic links added via script /apps/scripts/moveToPermHome.sh" >>${persistRoot}/config.sh
echo "######################################################################" >>${persistRoot}/config.sh
echo "" >>${persistRoot}/config.sh

for f in `cat $1` ; do
   origPath=`echo "$f" | sed "s/^\(.*\)\/\([^/]*\)/\1/g"`
   shortName=`echo "$f" | sed "s/^\(.*\)\/\([^/]*\)/\2/g"`
   moveit $origPath ${persistRoot}${origPath} $shortName ${persistRoot}/config.sh  
done

chmod a+x ${persistRoot}/config.sh


