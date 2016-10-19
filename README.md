# Angl-Resource-Pack
##An open-source vector based Minecraft resource pack.
# This is a WIP, some things have yet to be added to the catalogue
***

If you just want to download the resource pack, look here: https://github.com/W-Floyd/Angl-Resource-Pack-Export

***

###Usage

To render, run

	./render.sh <resolution>
	
To make a Minecraft ready zip file, run

	./make-pack.sh <resolution>
	
If no resolution is specified, sizes 32x32, 64x64, 128x128, 256x256, 512x512 will be packaged up

***
###To-do
####Make packaging scripts again.
***

This is *only* to showcase my method and history of development, hopefully to help someone else someday.

**It does not give you a right to take credit for my work.**

Open source doesn't mean you can do whatever you want with it. Follow common etiquette - this is my work, don't steal. Or 'borrow'.

You ***are*** free to use any included *scripts* in any way you like.
Having said that, I developed them in conjunction with the textures, meaning they are not a toolbox in themselves, but may be adapted to new images fairly easily.

Also, documentation could be better - I may eventually clean things up.

***

###Known issues

At one point I had to compile a newer version of Imagemagick from source to make some compositing work. If you get odd results, that may the issue.

Also, last I checked, glass was not transparent in Minecraft. Have yet to verify since redoing the script system.

***
