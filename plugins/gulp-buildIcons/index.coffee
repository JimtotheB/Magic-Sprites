_ = require "lodash"
through = require "through2"
gutil = require "gulp-util"
PluginError = gutil.PluginError
path = require "path"
fs = require "fs"

PLUGIN_NAME = "gulp-iconbuilder"

reg = new RegExp("(@).*(:).*(,).*(,).*(,).*(;)", "i")
counter = 0

hexToRGB = (h)->
  cutHex = (h) ->
    (if (h.charAt(0) is "#") then h.substring(1, 7) else h)
  R = (() ->
    parseInt (cutHex(h)).substring(0, 2), 16)()
  G = (() ->
    parseInt (cutHex(h)).substring(2, 4), 16)()
  B = (() ->
    parseInt (cutHex(h)).substring(4, 6), 16)()

  return "#{R},#{G},#{B}"

selector = (line)->
  return line.split(":")[0]

className = (selector)->
  return selector.split("@")[1].split("-")[0]

buildClass = (icon, selector, color)->
  if color isnt ""
    rgb = hexToRGB(color)
    c = """.#{icon} {
      .sprite(#{selector});
      background-color: rgb(#{rgb});
    }
    """
  else
    c = """.#{icon} {
      .sprite(#{selector});
    }
    """
  return c

createBuffers = (array, colors)->
  count = 0
  buffers = []
  buffers.push new Buffer("@import 'sprites';\n\n")
  for line,key in array
    if reg.test(line)
      s = selector(line)
      c = className(s)
      if c is colors[key].className
        append = buildClass("icon.#{c}", s, colors[key].hex)
        buffers.push new Buffer("#{append}\n\n")
        count++
  console.log buffers.length
  console.log count
  return buffers

buildIcon = (options = {dataFile: false, fileName: "magic.less"})->
#  prefixText = new Buffer(prefixText)
  stream = through.obj (file, enc, cb)->
    console.log file.path
    if not options.dataFile
      @push file
      cb()
      throw new PluginError(PLUGIN_NAME, "Options cannot be empty")
    if file.isNull()
      @push file
      cb()
    if file.isBuffer()
      array = file.contents.toString().split("\n")
      colors = require path.join(process.cwd(),options.dataFile)
      allBuffers = createBuffers(array, colors)

      newFile = new gutil.File
        base: "./"
        cwd: "./"
        path: "./#{options.fileName}"
        contents: Buffer.concat(allBuffers)
      @push(newFile)
    else

      @push file
      cb()


    @push(file)
    return cb()
  return stream
module.exports = buildIcon;