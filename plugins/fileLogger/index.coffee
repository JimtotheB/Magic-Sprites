path = require "path"
gutil = require "gulp-util"
PluginError = gutil.PluginError
through = require "through2"
fs = require "fs"

PLUGIN_NAME = "gulp-filelogger"



stripFilename = (p)->
  extname = path.extname(p)
  return path.basename(p, extname)

fileLogger = (log)->

  stream = through.obj (file, enc, cb)->
    console.log file.path
    console.log log if log
    @push(file)
    return cb()
  return stream


module.exports = fileLogger