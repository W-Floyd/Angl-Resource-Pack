# How to add textures

First off, look at existing textures for ideas on how to solve problems, but here is a decent guide.

***

Assuming the texture you wish to add does not rely on any other textures, the procedure should be straightforward. First, create the desired texture, either by copying and editing an exising texture, or by using the provided template.

Make sure this file is in the appropriate directoy, and you should be done with it for now. Let's also assume it is in the main blocks folder. So the next step is to add an entry in the catalogue file.

The catalogue file is more or less an XML formatted list of files and their attributes. I say more or less, as it is meant to follow XML formatting, but I have not checked it, nor have any want to change this. It is simple, in order to allow easy parsing through simple tools (sed, grep, etc.)

Copy an entry from an existing texture similar to your own. I *HIGHLY* recommend copying, as it is too easy to mess up otherwise. Let's use dirt as a base, and andesite as the goal texture, since it is a standalone texture also. So you should see:

```
	<ITEM>
		<NAME>./assets/minecraft/textures/blocks/dirt.png</NAME>
		<SCRIPT>%stdconf%/vector_basic_block.sh</SCRIPT>
		<SIZE></SIZE>
		<OPTIONS>dirt</OPTIONS>
		<KEEP>YES</KEEP>
		<IMAGE>YES</IMAGE>
		<DEPENDS></DEPENDS>
		<CLEANUP>./assets/minecraft/textures/blocks/dirt.svg</CLEANUP>
		<OPTIONAL>NO</OPTIONAL>
		<COMMON>Dirt</COMMON>
	</ITEM>
```

First, an explaination of the syntax in use here:

**ITEM** describes where to start and stop looking for each individual file to process.

**NAME** describes the output file name achieved. Formatted relative to the top folder of the resource pack.

**SCRIPT** describes what file is used to process the file. More on this later. Also formatted relative to the top folder of the resource pack. The use of the macro %stdconf% indicates the common folder for scripts which are included with furnace. Custom scripts usually go in './conf/'.

**SIZE** describes what size to process the file with. Rarely used. If blank, uses pack size. Mainly included for pack logo. Any positive integer will work.

**OPTIONS** describes any options to pass to the script. Placed after SIZE, as SIZE is passed as an option to all SCRIPT scripts.

**KEEP** describes whether the produced file is intended for inclusion in the final resource pack. YES or NO answer. So if you are processing a working only file (an overlay, for instance), this is set to NO. Otherwise, YES.

**IMAGE** describes whether the produced file is an image or not, for use in rescaling from a large size.

**DEPENDS** describes any files this file **directly** relies on. For instance, if your script pulls in a file derived from wool, the colour file, nor wool overlay are required, only the directly used file. The render script extrapolates this information for use, so there is no need to do it ourselves. It **shouldn't** break things, but it's bad form, and not tested.

**CLEANUP** describes the source files to delete upon completion of the resource pack. Again, formatted relative to the top folder of the resource pack. For images composed entirely from pre-rendered images, this will be blank.

**OPTIONAL** describes if the file is an optional render, useful for demo images.

**COMMON** describes the common name of the texture. This is optional, and might be hard to fill in at times. Only useful on KEEP files.

***

So, we've added an entry that looks like:

```
	<ITEM>
		<NAME>./assets/minecraft/textures/blocks/stone_andesite.png</NAME>
		<SCRIPT>%stdconf%/vector_basic_block.sh</SCRIPT>
		<SIZE></SIZE>
		<OPTIONS>stone_andesite</OPTIONS>
		<KEEP>YES</KEEP>
		<IMAGE>YES</IMAGE>
		<DEPENDS></DEPENDS>
		<CLEANUP>./assets/minecraft/textures/blocks/stone_andesite.svg</CLEANUP>
		<OPTIONAL>NO</OPTIONAL>
		<COMMON>Andesite</COMMON>
	</ITEM>
```

The script vector\_basic\_block.sh saves us re-writing a script for each file. There are a lot of blocks that need no special processing, this saves us a lot of redundant work. The option given is specific to this script, and our knowlege of the use.

All being well in the world, this should be ready for rendering.

So, run `furnace`, and the new texture should be found, rendered and packaged with the others.

***

Note that if you have unsatisfied dependancies, the script will proceed without that file and any dependant files. Overall, errors are unforgiving - things must be **perfect** to function correctly.

Also, to elaborate on the **COMMON** field, it is subjective. For example, 'Andesite' could just as easily have been 'Stone (Andesite)'. Up to you, just keep it consistant so grouping works.

***

## Helpful hints

Colours:
```
black
blue
brown
cyan
gray
green
light_blue
lime
magenta
orange
pink
purple
red
silver
white
yellow
```

Use that list for scripting and such, when you have to produce bulk textures (clay, glass, etc.)
