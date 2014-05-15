# Generic gulp tools
gulp = require "gulp"
jade = require "gulp-jade"
gutil = require "gulp-util"
watch = require "gulp-watch"
plumber = require "gulp-plumber"
rename = require "gulp-rename"
gulpif = require "gulp-if"
debug = require "gulp-debug"
runSequence = require "run-sequence"
through = require "through2"

# Css tools
sprite = require("css-sprite").stream
minifyCss = require "gulp-minify-css"
less = require "gulp-less"

# JS/CS tools
coffee = require "gulp-coffee"
coffeelint = require "gulp-coffeelint"
uglify = require "gulp-uglify"

# Html tools

# Livereload server
connect = require "gulp-connect"

#Project specific Plugins
fileLogger = require "./plugins/fileLogger"
buildIcons = require "./plugins/gulp-buildIcons"
buildData = require "./plugins/gulp-buildFileData"

fs = require "fs"
path = require "path"
# Outside config
config = require("configurizer").getVariables(false)
#Build variables
iconImagePath = config.iconImagePath


src =
  coffee: "./src/coffee/ghostsocial.coffee"
  less: "./build/less/#{config.cssFileName}.less"
  js: "./assets/js/ghostsocial.js"
  jade: "./server/**/*.jade"
  jadeIndex: "./server/index.jade"
  html: "./server/index.html"

dest =
  js: "./assets/js/"
  html: "./"

###
  Path Variables
###
RootDir = path.normalize(config.projectRoot)
IconImagePath = path.join(RootDir, config.iconImagePath)
IconDataFile = path.join(RootDir, config.iconDataPath)
IconDataPath = path.dirname(IconDataFile)
CssImagePath = path.join(RootDir, config.outPutImageDirectory)
CssOutputPath = path.join(RootDir, config.cssOutputDirectory)
CssOutputFile = "#{CssOutputPath}#{config.cssFileName}"

console.log CssOutputPath

gulp.task "buildImageData", ->
  gulp.src(IconDataPath)
#  .pipe plumber()
  .pipe buildData(imageDataFile: IconDataFile, imagePath: IconImagePath, iconSplit: config.iconSplitOnChar)
  .pipe gulp.dest(IconDataFile)



gulp.task "buildSprites", ->
  gulp.src("#{iconImagePath}**")
  .pipe plumber()
  .pipe sprite
#    name: "sprite.png"
    style: "sprites.less"
    base64: true
    cssPath: CssImagePath
    processor: "less"
  .pipe gulpif("*.png", gulp.dest(CssImagePath))
  .pipe gulpif("*.less", buildIcons(imageDataFile: IconDataFile, outPutFile: "#{config.cssFileName}.less"))
  .pipe gulp.dest("build/less")
  .pipe less()
  .pipe rename("#{config.cssFileName}.css")
  .pipe gulp.dest( CssOutputPath )
  .pipe gulp.dest("./server/")
  .pipe minifyCss()
  .pipe rename("#{config.cssFileName}.min.css")
  .pipe gulp.dest( CssOutputPath )



gulp.task "buildHtml", ->
  icons = JSON.parse( fs.readFileSync(IconDataFile, "utf8") )
  cssFile = "#{config.cssFileName}.css?v=#{Date.now()}"
  console.log cssFile
  locals = icons: icons, cssFile: cssFile
  gulp.src(src.jadeIndex)
  .pipe plumber()
  .pipe jade
    locals: locals
    pretty: true
  .pipe gulp.dest(dest.html)
  .pipe connect.reload()


gulp.task "buildJs", ->
  gulp.src( src.coffee )
  .pipe plumber()
  .pipe coffeelint()
  .pipe coffee(sourceMap: true)
  .pipe gulp.dest( dest.js )

gulp.task "minifyJs",["buildJs"], ->
  gulp.src( src.js )
  .pipe uglify()
  .pipe rename("ghostsocial.min.js")
  .pipe gulp.dest( dest.js )


gulp.task "server", ->
  connect.server
    root: "./"
    livereload: true
    port: 9000
    host: "0.0.0.0"


gulp.task "reloadServer", ["buildHtml"]

gulp.task "watchImages", (cb)->
  setTimeout (->
    watch({glob: "#{iconImagePath}**", read: false, emitOnGlob: false}, ["buildImageData"])
  ), 200
  cb()

gulp.task "watchFileData", (cb)->
  setTimeout (->
    watch(glob: "#{IconDataPath}/**/*", emitOnGlob: false, ["buildSprites"])
  ), 200
  cb()

gulp.task "watchCSS", (cb)->
  setTimeout (->
    watch(glob: ["#{CssOutputPath}**"], emitOnGlob: false, ["reloadServer"])
  ), 200
  cb()

gulp.task "build", (cb)->
  log = ->
    gutil.log gutil.colors.green("[Magic Sprites] Your CSS files are available in \n
    #{CssOutputFile}.css and #{CssOutputFile}.min.css")
  runSequence("buildImageData", "buildSprites", log)

gulp.task "watch", (cb)->
  runSequence(
    "watchImages","watchFileData", "server", "watchCSS", cb
  )

  setTimeout (->
    gulp.start("buildImageData")
  ), 500

gulp.task "test", (cb)->

  p = path.join(config.projectRoot, config.cssOutputDirectory)
  fs.readdir p, (err, files)->
    console.log files
    console.log RootDir
    console.log IconImagePath
    console.log IconDataPath
    console.log IconDataFile
    console.log CssOutputPath
    console.log CssOutputFile
    cb()