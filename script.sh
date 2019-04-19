#!/bin/bash

# Option 1: optional site to grab links from. Will visit those.
# Option 2: optional cut off for for loop looping through links to visit. Default: 5
# Option 3: optional end for sleep timer. Default: 15

site=${1:-"manual"}
num_links=${2:-3}
end_sleep=${3:-10}


echo $site
echo $num_links
echo $end_sleep


if [ $site != "manual" ]
then
	# get site and then parse through it to get all links
	wget -qO- $site |
	grep -Eoi '<a [^>]+>' | 
	grep -Eo 'href="[^\"]+"' | 
	grep -Eo '(http|https)://[^/"]+' > toVisit.txt


	echo "Possible links to visit"
	# remove duplicate strings. Some duplicate websites remain: https vs http, etc. Ignoring that.
	awk '!seen[$0]++' toVisit.txt
fi

# Visit files
filename='toVisit.txt'
filelines=`cat $filename`
link_count=0
for line in $filelines ; do
	echo $line
	if [ $link_count -eq $num_links ]; then
		break
	fi
	# Sleep for 1 - 15 seconds before so not an onslet of urls being opened at once
	sleep $(( ( RANDOM % $end_sleep )  + 1 ))
    open -a "Google Chrome" $line
    link_count=$((link_count+1))

done



