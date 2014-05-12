path = require "path"
gutil = require "gulp-util"
PluginError = gutil.PluginError
through = require "through2"
fs = require "fs"

PLUGIN_NAME = "gulp-getFilenames"



stripFilename = (p)->
  extname = path.extname(p)
  return path.basename(p, extname)

getFilenames = (options = fileName: "./data/my-imagedata.json")->
  Json = path.join process.cwd(), options.fileName
  exists = fs.existsSync Json
#    throw new PluginError PLUGIN_NAME, "your config file exists, to continue would destroy it."
  if not exists
    newData = []
    fs.writeFileSync(Json, JSON.stringify(newData))
  stream = through.obj (file, enc, cb)->
    if exists
      @push(file)
      return cb()
    else
      p = file.path
      bn = stripFilename(p)
      console.log bn
      data = require Json
      data.push className: bn, hex: ""
      fs.writeFileSync(Json, JSON.stringify(data, null, 2))
      @push(file)
      return cb()
  return stream


module.exports = getFilenames

