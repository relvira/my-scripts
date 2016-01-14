#!/bin/bash
#
# Downloads subtitles for TVShows and Movies recently downloaded, we'll upload all this later to a Plex server
# BE AWARE: This script is awful but it works, I know i can do this with a find, I'll update the script ASAP
#

DOWNLOAD_FOLDER='/Users/ret/Downloads/torrent/finished/'
INSPECT_DEPTH=3
DEPTH_REACHED=0
INSPECT_FORMATS= ['mkv','mp4','avi']

download_subtitle() {
	CURFILE=$1
	echo "+ Checking file format for "$CURFILE
	# TODO: Check file format and download if ok
	echo "+ Downloading subtitle for file "$CURFILE"..."
	/usr/bin/subtitle_downloader $CURFILE
}

inspect_directory() {
	CURDIR=$1
    DEPTH_REACHED=$((DEPTH_REACHED + 1))

	for obj in "$CURDIR"/*
	do
		if [[ -d $obj ]]; then
			if [ "$DEPTH_REACHED" -lt "$INSPECT_DEPTH" ]; then
				inspect_directory "$obj"
			else
				echo " \t \t - Inspect depth reached, stopping..."
			fi
		elif [[ -f $obj ]]; then
			download_subtitle "$obj"
		else
		    echo " \t \t + $obj is not valid"
			#exit 1
		fi
	done
}


echo "> Inspecting directory: "$DOWNLOAD_FOLDER
for file in $DOWNLOAD_FOLDER*
do
	DEPTH_REACHED=0
	if [[ -d $file ]]; then
		inspect_directory "$file"
	elif [[ -f $file ]]; then
		download_subtitle "$file"
	fi
done



echo "Done!"
