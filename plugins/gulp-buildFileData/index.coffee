path = require "path"
gutil = require "gulp-util"
PluginError = gutil.PluginError
through = require "through2"
fs = require "fs"
_ = require "lodash"

PLUGIN_NAME = "buildFileData"

buildImageData = (files, existingData, split)->

  #closure, because why not?
  objectify = (f, k)->
    extname = path.extname(f) #Image file
    className = path.basename(f, extname)

    #if a split character was provided, remove the offending chars
    if split
      className = className.split(split)[0]

    #default output
    data = data = className: className, hex: ""

    #If we have existing data, loop through it and extract.
    if existingData?
      ex = _.find existingData, className: className
      data = ex if ex?

    return data

  gutil.log  gutil.colors.green("[#{PLUGIN_NAME}] Building image data for #{files.length} files." )
  objectify f, k for f, k in files


getFilenames = (options)->
  if not options
    err = "You must provide values for iconImagePath: , iconDataPath: and iconSplitOnChar: in config.yaml"
    throw new PluginError PLUGIN_NAME, gutil.colors.red(err)

  stream = through.obj (file, enc, cb)->
    images = path.join process.cwd(), options.inputFile

    #If The data file exists we need to pull it in and pass it to the parser.
    fs.exists options.outputFile, (exists)=>

      #read in the existing data file
      existingData = JSON.parse( fs.readFileSync(options.outputFile, "utf8") ) if exists
      fs.readdir images, (err, files)=>
        #Compare and parse data, then create a new vinyl object
        dataObject = buildImageData(files, existingData, options.iconSplit)
        newFile = new gutil.File
          base: "./"
          cwd: "./"
          path: "./"
          contents: new Buffer JSON.stringify(dataObject, "", 2)

        @push newFile
        cb()
  return stream


module.exports = getFilenames
