#! /bin/bash
DISPLAY=:0
XAUTHORITY=/run/user/1000/lyxauth
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

paths=()
length=$(cd ~/Pictures/wallpaper && ls -l |wc -l)
cap=$(($length - 1))
number=$(cat ~/Documents/bash/paper/number.txt)
lastLength=$(cat ~/Documents/bash/paper/length.txt)

#checks if no paramaters were set
if [[ -z $1 ]]; then

#get the names of the file paths
for i in seq 1 $cap; do
for file in ~/Pictures/wallpaper/*;
do
paths+=( $file )
done
done

if [[ $number -le $cap   &&  $lastLength -eq $length ]]; then
        nextNum=$(($number + 1))
        echo $nextNum > ~/Documents/bash/paper/number.txt
	#GNOME syntax: gsettings set org.gnome.desktop.background picture-uri-dark ${paths[$number]}
	image=$(sed -n "${number}p" ~/Documents/bash/paper/iteratedPaths.txt)
	plasma-apply-wallpaperimage ${paths[$image]} > /dev/null

else

init=()


echo "1" > ~/Documents/bash/paper/number.txt
# create the inital array
for (( i = 1 ; i <= $length ; i++ )); do
        out=${paths[$i]}
        init+=($i)
done

end=( $(shuf -e "${init[@]}") )

# create the shuffled array

echo ${end[0]} > ~/Documents/bash/paper/iteratedPaths.txt
for (( i = 1 ; i <= $length ; i++ )); do
      echo ${end[$i]} >> ~/Documents/bash/paper/iteratedPaths.txt
done

image=$(sed -n "${length}p" ~/Documents/bash/paper/iteratedPaths.txt)
plasma-apply-wallpaperimage ${paths[$image]}

fi

echo $length > ~/Documents/bash/paper/length.txt

else #if there are parameters
exec > /dev/null 2>&1 #stop outputting to terminal
        backgroundParam="/home/max/Pictures/wallpaper/"$1
        potentialParam="/home/max/Pictures/potentialWallpaper/"$1
        dirParam="$(pwd)"/$1
        if [ $(cd / && cat $1 | wc -c) -gt 0 ]; then
        plasma-apply-wallpaperimage "$1"
        elif [ $(cd / && cat "$dirParam" | wc -c) -gt 0 ]; then
        plasma-apply-wallpaperimage "$dirParam"
        elif [ $(cd / && cat "$backgroundParam" | wc -c) -gt 0 ]; then
        plasma-apply-wallpaperimage "$backgroundParam"
        elif [ $(cd / && cat "$potentialParam" | wc -c) -gt 0 ]; then
        plasma-apply-wallpaperimage $potentialParam
        else
exec > /dev/tty 2>/dev/tty #resume output
        echo "Not a real path"
        fi
exec > /dev/tty 2>/dev/tty
fi
