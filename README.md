#Magic Sprites

####Build and customize css sprite sheets from a directory of images.

##### Magic Sprites relies on node-canvas, Installation instructions for your system can be found here [Node-Canvas](https://github.com/learnboost/node-canvas/wiki)

## Installation 

    $ bower install MagicSprites
    $ cd bower_components/MagicSprites
    $ npm install


####Basic Workflow

    $ gulp build #your compiled css will be in ./assets/css/magic.min.css
    
    $ gulp watch 
    # Will launch a preview server at http://localhost:9000. 
    # It reloads on changes.
    

This will build a spritesheet and associated css file from simple-Icons ./images/icons_white/48px
The background-color data for this build can be found at ./data/simple-icons.json


####Advanced workflow - building from your own images.

Upload images to ./images/my-images -> edit ./config.json -> gulp init -> gulp build -> gulp watch

./config.json needs to contain

    {
        "iconImagePath": "./images/my-images/*.png",
        "iconDataPath": "./data/my-imagedata.json",
        "cssFileName": "myCss"
    }

iconImagePath - Relative path to your images.
iconDataPath - Relative path to the image data file. (this will be generated for you with "gulp init")
cssFileName - The name of the final css file to be output.

gulp init - Reads the list of image files, outputting the filename to ./data/my-imagedata.json
If you want to build the project as is just run "gulp build" and it will use that data to output css with no further modification.
This is great for solid color images.

If you have transparent background images, and wish to assign a css color to them, simply add the hex color code (with or without the #)
to the "hex": field in ./my-imagedata.json.

