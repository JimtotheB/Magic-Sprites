#Magic Sprites

####Build and customize css sprite sheets from a directory of images.

##### Magic Sprites relies on node-canvas, Installation instructions for your system can be found here [Node-Canvas](https://github.com/learnboost/node-canvas/wiki)
##### Magic Sprites contains all of @danleech (Simple-Icons)[https://github.com/danleech/simple-icons] using the 48px versions by default.

## Installation

    $ bower install MagicSprites
    $ cd bower_components/MagicSprites
    $ npm install


####Basic Workflow

    $ gulp build #your compiled css will be in ./assets/css/magic.min.css
    
    $ gulp watch 
    # Will launch a preview server at http://localhost:9000. 
    # Reloads on changes.
    

This will build a spritesheet and associated css file from simple-icons ./images/icons_white/48px
The background-color data for this build can be found at ./data/simple-icons.json


####Advanced workflow - building from your own images.

Put images in ./images/my-images -> edit ./config.yaml -> gulp build / gulp watch

./config.yaml needs to contain

    projectRoot: "./"

    iconImagePath: "images/icons_white/48px/"

    iconDataPath: "data/simple-icons.json"

    iconSplitOnChar: "-"

    cssFileName: "magic"

iconImagePath - Relative path to your images. No beginning /
iconDataPath - Relative path to the image data file. (this will be generated for you with "gulp build")
iconSplitOnChar - this is only needed for files appended with -32, -64, -some-junk, it will remove everything after the "-" when it
    generates classnames. Set to "iconSplitOnChar: false" without quotes if your images do not include this feature.
cssFileName - The name of the final css file to be output.

gulp build - Reads the list of image files, outputting the filenames to ./data/my-imagedata.json

If you have transparent background images, and wish to assign a css color to them, simply add the hex color code (with or without the #)
to the "hex": field in ./my-imagedata.json.

#### Preview server

    $ gulp watch

Fires up an express server bound to 0.0.0.0:9000 (http://localhost:9000 or http://internal.server:9000 if you are like me and work on a VM)

Css will be rebuilt on addition of images and changes to ./data/my-imagedata.json, and will be auto-refreshed on your browser.


#A note on Bower

For the sake of development, all of the built files stay relative to the bower directory. This is probably not good practise,
if you value your data. In a real installation you most likely want to use paths outside the MagicSprites directory.


./config.yaml needs to contain

    projectRoot: "absolute/path/to/project"

    iconImagePath: "images/icons_white/48px/"

    iconDataPath: "data/simple-icons.json"

    iconSplitOnChar: "-"

    cssOutputDirectory: "assets/css/"

    cssFileName: "magic"
