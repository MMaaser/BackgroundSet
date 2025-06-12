#! /bin/bash
DISPLAY=:0
XAUTHORITY=/run/user/1000/lyxauth
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

paths=()
length=$(cd ~/Pictures/background && ls -l |wc -l)
cap=$(($length - 1))
number=$(cat ~/Documents/bashScripts/number.txt)
lastLength=$(cat ~/Documents/bashScripts/length.txt)

#get the names of the file paths
for i in seq 1 $cap; do
for file in ~/Pictures/background/*;
do
paths+=( $file )
done
done

if [[ $number -le $cap   &&  $lastLength -eq $length ]]; then
        nextNum=$(($number + 1))
        echo $nextNum > ~/Documents/bashScripts/background/number.txt
	#GNOME syntax: gsettings set org.gnome.desktop.background picture-uri-dark ${paths[$number]}
	image=$(sed -n "${number}p" ~/Documents/bashScripts/iteratedPaths.txt)
	plasma-apply-wallpaperimage ${paths[$image]}

else

init=()


echo "1" > ~/Documents/bashScripts/number.txt
#GNOME syntax: gsettings set org.gnome.desktop.background picture-uri-dark ${paths[0]}
# create the inital array
for (( i = 1 ; i <= $length ; i++ )); do
        out=${paths[$i]}
        init+=($i)
done

end=( $(shuf -e "${init[@]}") )

# create the shuffled array

echo ${end[0]} > ~/Documents/bashScripts/iteratedPaths.txt
for (( i = 1 ; i <= $length ; i++ )); do
      echo ${end[$i]} >> ~/Documents/bashScripts/iteratedPaths.txt
done

image=$(sed -n "${length}p" ~/Documents/bashScripts/iteratedPaths.txt)
plasma-apply-wallpaperimage ${paths[$image]}

fi

echo $length > ~/Documents/bashScripts/length.txt

sleep 2

#convert accent color into hsl
color1=$(grep -E "Highlight=|DecorationHover=" ~/.config/kdeglobals | sed -n 1p )
color2=$(echo "${color1:16}") #rgb values
color3=$(pastel format hsl "rgb($color2)") #hsl values
                                                 
#grab the hue of the hsl value
colorlength=$(echo $color3 | wc -c )
commafound=false
endval=0

for (( i=0 ; $i < $colorlength ; i++ )); do
char=${color3:$i:1}
if [ $commafound = false ] && [[ "$char" = "," ]]; then
	endval=$i
commafound=true
fi
done

hue=$( echo "${color3:0:$endval}")

# The color codes corresponding to the different iterations of the default theme color:

rgb1="rgb(86,87,245)"
rgb2="rgb(66,133,244)"
rgb3="rgb(89,151,244)"
rgb4="rgb(82,148,226)"

#converts the color into one with the same saturation and brightness but a hue belonging to the background generated accent color

tempval=0

hue_converter () {

        #$1 is rgb
#$2 is the hue
        # convert to hsl
        hsl=$(pastel format hsl $1)

        #find the first comma/ending of the hue value
        hsl1length=$( echo $hsl | wc -c) 
        hslcommafound=0
        hslstart=0
        for (( i = 0 ; $i < $hsl1length ; i++ )); do
                char=${hsl:$i:1}
                if [ $hslcommafound == 0 ] && [[ "$char" == "," ]]; then

                        hslcommafound=1
                        hslstart=$i
                fi
        done

        hslback=${hsl:$hslstart}


        hsl2=$(echo $2$hslback )
        rgbee=$(pastel format rgb "$hsl2")
        almost="${rgbee// /}"
        tempval="${almost:4}"


}

#change hues of theme colors
hue_converter $rgb1 $hue
c1=$tempval
hue_converter $rgb2 $hue
c2=$tempval
hue_converter $rgb3 $hue
c3=$tempval
hue_converter $rgb4 $hue
c4=$tempval

#correct those rgbs to fit the Layan colors format by removing spaces and the first four chars

#replace all instances of default theme rgbs
# sed -i "/overwrite_all_lines_containing_this_string/c\/text_to_overwrite"

#1 / 86,87,245 | schizophrenic because DecorationFocus is defined differently in mutliple categories
sed -i "24c\DecorationFocus=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "25c\DecorationHover=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "52c\DecorationFocus=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "53c\DecorationHover=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "66c\DecorationFocus=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "67c\DecorationHover=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "79c\BackgroundNormal=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "80c\DecorationFocus=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "81c\DecorationHover=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "94c\DecorationFocus=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "95c\DecorationHover=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "108c\DecorationFocus=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "109c\DecorationHover=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "122c\DecorationFocus=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "123c\DecorationHover=$c1" ~/.local/share/plasma/desktoptheme/BetterLayan/colors

#2 / 66,133,244
sed -i "/ForegroundLink/c\/ForegroundLink=$c2" ~/.local/share/plasma/desktoptheme/BetterLayan/colors
sed -i "38c\DecorationFocus=$c2" ~/.local/share/plasma/desktoptheme/BetterLayan/colors

#3 / 89,151,244
sed -i "39c\DecorationHover=$c3" ~/.local/share/plasma/desktoptheme/BetterLayan/colors

#4 / 82,148,226
sed -i "78c\BackgroundAlternate=$c4" ~/.local/share/plasma/desktoptheme/BetterLayan/colors


#FASTFETCH CONFIG

#converts the rgb output into a bash-friendly one
ffrgb0="${color2//,/;}"
ffrgb=$(echo "38;2;"$ffrgb0)
#overwrites the first color for the logo
sed -i "14c\ \"1\": \"$ffrgb\"," ~/.config/fastfetch/config.jsonc
#overwrites the second color
sed -i "15c\ \"2\": \"$ffrgb\"" ~/.config/fastfetch/config.jsonc
#overwrites key color
sed -i "21c\ \"keys\": \"$ffrgb\"," ~/.config/fastfetch/config.jsonc

# clear all caches for the theme
rm -r ~/.cache/plasma*

#restart plasmashell
# systemctl --user restart plasma-plasmashell
