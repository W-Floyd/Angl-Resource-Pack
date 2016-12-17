# Angl-Resource-Pack
##An open-source vector based Minecraft resource pack.
### This is a WIP, *many* textures have yet to be added, but the script system is (mostly?) done
***
If you just want to download the resource pack, look here: https://github.com/W-Floyd/Angl-Resource-Pack-Export

***

The whole render system may be broken at any given time, especially if I have been commiting recently. Unless you see me adding textures and not un-breaking my scripts, proceed with extreme caution.

***

###Usage

To make a Minecraft ready zip file, run

	./make-pack.sh <resolution>
	
If no resolution is specified, sizes 32x32, 64x64, 128x128, 256x256 and 512x512 will be packaged up

***

To only render, and not zip, run

	./render.sh <resolution>
	
This is not recommended, please use make-pack.sh, it cleans up after itself.
	
If no resolution is specified, the pack will be rendered at size 128x128

***

If things don't render properly after modifying some stuff, just delete the Angle-*px folders and re-render. This shouldn't happen, so if it does, please add an issue and describe the file changed so I can fix it.

***

This is *mostly* to showcase my method and history of development, hopefully to help someone else someday.

**It does not give you a right to take credit for my work.**

Open source doesn't mean you can do whatever you want with it. Follow common etiquette - this is my work, don't steal. Or 'borrow'.

You ***are*** free to use any included *scripts* in any way you like.
Having said that, I developed them in conjunction with the textures, meaning they are not a toolbox in themselves, but may be adapted to new images fairly easily.

Also, documentation could be better - I may eventually clean things up.

***

If you wish to add textures, use the included template.svg  
It includes preset grids and canvas size to keep you on track.

###Known issues

At one point I had to compile a newer version of Imagemagick from source to make some compositing work. If you get odd results, that may be the issue. This *seems* to have been solved by setting some options on all image operations.

Size 1024 is known to cause errors due to large images, and so 512px is the largest default size. It does look damn good though.

***
