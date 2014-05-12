###Magic Sprites
####Build and customize css sprite sheets from a directory of images.

####Basic Workflow

Clone project -> npm install -> gulp build -> gulp watch

This will build a spritesheet and associated css file from simple-Icons ./images/icons_white/48px
The background-color data for this build can be found at ./simple-icons.json

gulp build - compiles your images into a sprite sheet, generates less css files, and finally compiles them to css.
gulp watch - will launch a preview server available at http://localhost:9000 this is useful if you plan to further edit data.

####Advanced workflow - building from your own images.

Upload images to ./images/my-images -> edit ./config.json -> gulp init -> gulp build -> gulp watch

./config.json needs to contain

    {
        "iconImagePath": "./images/my-images/*.png",
        "iconDataPath": "./my-imagedata.json",
        "cssFileName": "myCss"
    }

iconImagePath - Relative path to your images.
iconDataPath - Relative path to the image data file. (this will be generated for you with "gulp init")
cssFileName - The name of the final css file to be output.

gulp init - Reads the list of image files, outputting the filename to ./my-imagedata.json
If you want to build the project as is just run "gulp build" and it will use that data to output css with no further modification.
This is great for solid color images.

If you have transparent background images, and wish to assign a css color to them, simply add the hex color code (with or without the #)
to the "hex": field in ./my-imagedata.json.

