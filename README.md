#Magic Sprites

####Build and customize css sprite sheets from a directory of images.

##### Magic Sprites relies on node-canvas, Installation instructions for your system can be found here [Node-Canvas](https://github.com/learnboost/node-canvas/wiki)
##### Magic Sprites contains all of @danleech [Simple-Icons](tps://github.com/danleech/simple-icons) using the 48px versions by default. Incidentally this is what prompted this project, me trying to sensibly convert his images into a spritesheet.

## Installation

    $ bower install MagicSprites
    $ cd bower_components/MagicSprites
    $ npm install


####Basic Workflow
    # ./your/project/bower_components/MagicSprites
    $ gulp build #your compiled css will be in ./assets/css/magic.min.css
    
    # or...
    
    $ gulp watch 
    # Will do all of the same stuff as gulp build
    # Plus launch a preview server at http://localhost:9000. 
    # It reloads on any changes to ./data/simple-icons.json or any additions 
    # to ./images/icons_white/48px/
    

This will build a spritesheet and associated CSS file from simple-icons ./images/icons_white/48px
The background-color data for this build can be found at ./data/simple-icons.json


####Advanced workflow - building from your own images.
#####See note at bottom about developing inside bower_components (ie: don't)
Put images in ./images/my-images -> edit ./config.yaml -> gulp build / gulp watch

./config.yaml needs to contain

    projectRoot: "./"

    iconImagePath: "images/icons_white/48px/"

    iconDataPath: "data/simple-icons.json"

    iconSplitOnChar: "-"
    
    outputImageDirectory: "assets/images/"
    
    cssOutputDirectory: "assets/css/"
    
    cssFileName: "magic"

* iconImagePath - Path to your images, relative to projectRoot. No beginning /
* iconDataPath - Relative path to the image data file. (this will be generated for you with "gulp build")
* iconSplitOnChar - this is only needed for files appended with -32, -64, -some-junk, it will remove everything after the "-" when it
    generates classnames. Set to "iconSplitOnChar: false" without quotes if your images do not have annotations.
* outPutImageDirectory - By default Magic Sprites encodes the png spritesheet as Base64 and includes it inside the resulting CSS file. This saves a request against your server. Changing this setting does nothing, without changing a setting in gulpfile.coffee
* cssOutputDirectory - Where do you want the CSS file to be output, relative to projectRoot.
* cssFileName - The name of the final CSS file to be output.


If you have transparent background images, and wish to assign a CSS color to them, simply add the hex color code (with or without the #)
to the "hex": field in my-imagedata.json.

#### Preview server

    $ gulp watch

Fires up an express server bound to 0.0.0.0:9000 (http://localhost:9000 or http://internal.server:9000 if you are like me and work on a VM)

Css will be rebuilt on addition of images and changes to ./data/my-imagedata.json (or wherever they are set to), and will be auto-refreshed on your browser.


#A note on Bower and bower_components

For the sake of development, all of the built files stay relative to the bower directory. This is probably not good practise,
if you value your data. In a real installation you most likely want to use paths outside the MagicSprites directory.


./config.yaml needs to contain

    projectRoot: "absolute/path/to/project"

    iconImagePath: "images/icons_white/48px/"

    iconDataPath: "data/simple-icons.json"

    iconSplitOnChar: "-"
    
    outPutImageDirectory: "assets/images/"
    
    cssOutputDirectory: "assets/css/"

    cssFileName: "magic"

#Additional caveats

This is a beta project, running on a beta build tool, running on a beta platform, and it manipulates files. It doesnt delete anything, simply overwrites files that match. So please dont post an issue here if you named your data file /etc/shadow and are wondering what went wrong.

If you have any other issues, suggestions or improvements feel free to submit an issue or a PR. 

