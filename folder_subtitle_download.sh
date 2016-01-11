#/bin/bash


DOWNLOAD_FOLDER='/Users/ret/Downloads/torrent/finished/*'
INSPECT_DEPTH=2

for obj in $DOWNLOAD_FOLDER
do
	if [[ -d $obj ]]; then
	    echo "$obj is a directory"
		for file in $obj
		do
			##### code here
		done
	elif [[ -f $obj ]]; then
	    echo "$obj is a file"
	else
	    echo "$obj is not valid"
		#exit 1
	fi
done

echo "Done!"
