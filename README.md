# Angl-Resource-Pack
##An open-source vector based Minecraft resource pack.
### This is a WIP, *many* textures have yet to be added, but the script system is (mostly?) done
***
If you just want to download the resource pack, look here: https://github.com/W-Floyd/Angl-Resource-Pack-Export

***

The whole render system may be broken at any given time, especially if I have been commiting recently. Unless you see me adding textures and not un-breaking my scripts, proceed with extreme caution.

***

Requires:
* Inkscape and/or rsvg-convert
* tsort

***

###Usage

Please use

	./make-pack.sh -h
	
to check for further instructions.

***

To make a Minecraft ready zip file, run

	./make-pack.sh <resolution>
	
If no resolution is specified, sizes 32x32, 64x64, 128x128, 256x256 and 512x512 will be packaged up

***

The use of the flag "-q" will use rsvg-convert, which is significantly faster than inkscape. The script will check if it is installed or not, so it is safe to use.

	./make-pack.sh -q <resolution>
	
	
	
In trials on my PC at one point in time, the following results were obtained (Both times, the xml file was pre-computed.) Specs were i7-6500U, 16GB RAM, 256GB SSD.

    time ./make-pack.sh 32 64 128 256 512 -v -q
    
    ...
    
    real    2m29.062s
    user    2m45.957s
    sys     0m31.516s
    
    
    
    time ./make-pack.sh 32 64 128 256 512 -v
    
    ...
    
    real    4m13.155s
    user    4m22.178s
    sys     0m37.521s

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

If you cancel a partial render, there will be an initial delay as the xml catalogue is parsed. Will see if I can do anything about that.

Sizes 1024px and above are known not to be loaded in Minecraft, and so 512px is the largest default size. 4096px is the largest size I have sucessfully processed (over 15 minutes), as 8192px segfaults when I run out of memory (16gb RAM + 4gb swap).

***
