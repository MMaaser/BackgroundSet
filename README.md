# BackgroundSet
KDE Random Background Set

Fine-tuned to my machine, but should be easily editable. It iterates through a randomly generated list of downloaded backgrounds (not included). Then, it sets system and fastfetch colors to the KDE-generated-from-wallpaper accent color saturation and brightness shifted to the saturation and brightness of the default Layan value. I did not write this with the intent of other people using it; this is only up here so I don't lose it when I inevitably brick my laptop, so excuse the to do list at the bottom.

Dependencies:
pastel: https://github.com/sharkdp/pastel

Editing to fit your machine:
These files were referenced in ~/Documents/bashscripts/background 
It checks for backgrounds in ~/Pictures/backgrounds
My theme is called BetterLayan and is based off Layan. Go into ~/.local/share/plasma/desktoptheme, copy the theme you want to use as a base, then change BetterLayan to the name of that copied theme.
My theme has 4 non-neutral theme colors I wanted changed with values assigned in proper rgb format to variables rgb1, rgb2, rgb3, and rgb4. If you're not using Layan, you'll probably have to go over the colors file in your copied theme folder to find the things you want changed. I'd suggest pastel to parse the colors if you can't eyeball them. Remember any instance of those colors you want changed in your file. If they're in different spots than the line numbers in the sed statements, change those line numbers. 
For the fastfetch jsonc file, it appends the key in the key/value pair to the front of the rgb values. I modified the "colors" block and "key". Check to make sure sed is writing to the correct line number. 
