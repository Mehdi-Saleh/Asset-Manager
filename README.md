# Asset Manager

This is a tag-based assets management tool that I'm developing for management of my many different assets.

## Key Features:
- Importing any file format 
- Thumbnail generation for common 2D and 3D file formats (work in progress, only gltf/glb format is currentlly supported for 3D files)
- Automatic and configurable identification of different file types (2D graphics, 3D graphics, audio, etc.)
- Viewing and searching assets based on their name, tags, license or file type


## How to Use
Use the import tab for importing new assets and the browse tab for browsing and searching everything.
- Enter a text to search for in asset names.
- Use commands search for specific information

### Search Commands ###
The currently available commands are:
- *:tag* for searching for specific tag(s)
- *:license* for showing assets with a specific license
- *:type* for showing assets of the specified file type
(You can also click on a tag, etc. to search for it.)

Example: 
- ":license CC0" will show every asset with a CC0 license.
- ":tag Texture Funny" will show assets that have either of Texture or Funny tags. (searching only for the ones with both tags is not yet implemented.)


**IMPORTANT:** Please note that this application does not change the actual asset files but still it's your responsibility to back-up your data!
