Bryce Reinhard
Digital forensics
Project

The project idea was some sort of way to spoof the data that google is storing on a user. This script visits every url that is stored in toVisit.txt. If a site is passed in as a parameter (IE: ./script.sh www.google.com) the script will wget that site, parse through the html file for links, and then open a new chrome tab for that url. There is an optional limit (default is 3) of how many links you want to visit. Since a bunch of pretty random tabs opening up at once is pretty suspicious, there is a sleep call before opening the tabs that can go from 1 - N (default for N is 10 seconds). There is more info below about optional values to be passed in. If you check Chrome history (cmd/control Y for a shortcut) you will see that the history is being changed.


Potential options:
./script.sh: website_to_grab_links_from | number_of_links_to_vist | upper bound of sleep
The default values in script: "manual", 3, 10
Manual means that you don't want to grab links from a site and want to put urls in toVisit.txt yourself.

Since a website_to_grab_links_from is required in order to change the other default values if you don't want to grab links from a site just pass in manual yourself. Example:

./script.sh manual 5 12





Code:
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
	# Sleep for 1 - end_sleep seconds before so not an onslet of urls being opened at once
	sleep $(( ( RANDOM % $end_sleep )  + 1 ))
    open -a "Google Chrome" $line
    link_count=$((link_count+1))

done







