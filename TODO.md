# TODO list

***

## Render script
Change appropriate functions over to comm, instead of grep  
Rename CONFIG field to SCRIPT field.

***

## Greater goals
* generic mobile render script should allow for any partial stage of completion
* all pack folders should be put into a 'build' directory, as should split xml (keep source clean)
* all current 'conf' files should be moved out of src once again, possibly into a folder of the same name. This is required in order to most pedantically avoid collisions and keep good form
* build-time xml splitting (re-used within render batch only). This will require *fast*, *efficient* and *comprehensive* xml work, specifically dependency resolution and error reporting before render time

The following features are deemed high priority additions:
* gracefully exiting a render - finishing the current item, before performing any cleanup needed, if any (it would be prefered it not exist)
* resumable renders (where good build-time xml work and graceful exiting is essensial)
* parallel rendering (isolating render environment would be one option, or a reworking of the script system to allow graceful coexistance, later would be preferable)

Overall, this will require at least one thing:
#### Language change
A more powerful and susinct programming language will be required for the render system (though individual file render scripts should remain). I am currently considering my options, and will either go the easier scripting route that is Python, or the more powerful, though less easily learnt C++ (or even C). Either of these routes will provide a much more robust sytem with which to work. That, combined with a clearer goal of my render system, should provide the desired speed and functions.

#### 

## Textures

Finish leaves  
Complete chests, crafting bench, furnace.  
Complete torch  
