#!/bin/bash
#
# Note: This script must be runned from crontab each ~1hour, we need to give time to the network
#       to upload all pending files, there may be a lot of content here...
#
#  ifconfig eth0 mtu 1492

PLEX_SERVER="192.168.79.4"
PLEX_USER="ret"
INSPECT_DIR="/shared/torrent/finished"
PLEX_SERVER_DESTINATION_DIR="/media/NAS/Torrent/"
SCP_FORMAT_PATTERN="" # Only upload files with this pattern, ignore shitty torrent txt and images
DATE=`date +%Y-%m-%d:%H:%M:%S`


echo "---------------------------------------------------------"
echo "- PLEX SERVER FILE UPLOADER (PENDING DOWNLOADS) / $DATE -"
echo "---------------------------------------------------------"
echo " "

if [ "$(ls -A $INSPECT_DIR)" ]
then
        echo "Deleting all unwanted files... only keeping *.mp4, *.avi, *.srt, *.mkv"
        find $INSPECT_DIR -type f ! -name '*.mkv' -or -name '*.mp4' -or -name '*.avi' -or -name '*.srt' -delete
	FILECOUNT=$(ls -l $INSPECT_DIR | wc -l)
  	echo "Inspected folder contains: $FILECOUNT files"
  	
	if ping -c 1 $PLEX_SERVER &> /dev/null
	then
		echo "Plex server is UP and running!!"
		echo "Uploading pending files to Plex server"
		scp -c blowfish -v -C -r $INSPECT_DIR/* $PLEX_USER@$PLEX_SERVER:$PLEX_SERVER_DESTINATION_DIR/.
    #rsync -avz --chmod=ugo=rwx --exclude-from -e "ssh -i ~/.ssh/id_rsa" "$INSPECT_DIR/*" "$PLEX_USER@PLEX_SERVER:$PLEX_SERVER_DESTINATION_DIR"
		if [ "$?" -eq "0" ];
		then
		    echo "Upload OK! Deleting pending files..."
		    rm -rf $INSPECT_DIR/*
		else
		    echo "Upload FAILED, we're keeping the files for the moment"
		fi
		
	else
	  echo "Plex server is DOWN, we'll try later..."
	fi
else
  	echo "Inspected folder is empty, ignoring.."
fi




