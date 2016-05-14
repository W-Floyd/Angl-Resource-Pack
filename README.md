# Angl-Resource-Pack
##An open-source vector based Minecraft resource pack.
***

If you just want to download the resource pack, look here: https://github.com/W-Floyd/Angl-Resource-Pack-Export

***

###Usage

To render and pack in 8px, 16px, 32px, 64px, 128px, 256px and 512px sizes, run

	bash Make-Pack.sh

To render a pack in a specific resolution, run

	bash Make-Pack.sh <resolution>

***

***ALSO NOTE*** - I have made extensive use of multiple hardlinks in the work here! Git does not support hardlinks - so cloning would be largely useless. As a workaround, I have included a .tar archive of the src folder which includes hardlinks properly. I will try to update this after any changes are made to src.

This basically means development is Linux only - sorry, not sorry ;)

***

This is *only* to showcase my method and history of development, hopefully to help someone else someday.

**It does not give you a right to take credit for my work.**

Open source doesn't mean you can do whatever you want with it. Follow common etiquette - this is my work, don't steal. Or 'borrow'.

You ***are*** free to use any included *scripts* in any way you like.
Having said that, I developed them in conjunction with the textures, meaning they are not a toolbox in themselves, but may be adapted to new images fairly easily.

Also, documentation could be better - I may eventually clean things up.

***

###Known issues

I had to compile a newer version of Imagemagick from source to make some compositing work. If you get odd results, that may the issue.

***
