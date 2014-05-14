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
  css: "./assets/css/"
  images: "./assets/images"
  html: "./"


gulp.task "buildImageData", (cb)->
  gulp.src("./data/")
  .pipe plumber()
  .pipe buildData(outputFile: config.iconDataPath, inputFile: config.iconImagePath, iconSplit: config.iconSplitOnChar)
#  .pipe debug( verbose: true)
  .pipe gulp.dest(config.iconDataPath)

  cb()


gulp.task "buildSprites", (cb)->
  gulp.src("#{iconImagePath}**")
  .pipe plumber()
  .pipe sprite
#    name: "sprite.png"
    style: "sprites.less"
    base64: true
    cssPath: dest.images
    processor: "less"
  .pipe gulpif("*.png", gulp.dest(dest.images))
  .pipe gulpif("*.less", buildIcons(dataFile: config.iconDataPath, outPutFile: "#{config.cssFileName}.less"))
  .pipe gulp.dest("./build/less")
  .pipe less()
  .pipe rename("#{config.cssFileName}.css")
  .pipe gulp.dest( dest.css )
  .pipe minifyCss()
  .pipe rename("#{config.cssFileName}.min.css")
  .pipe gulp.dest( dest.css )

  cb()


gulp.task "buildCss", (cb)->
  gulp.src( src.less )
  .pipe plumber()
  .pipe less()
  .pipe rename("#{config.cssFileName}.css")
  .pipe gulp.dest( dest.css )
  .pipe minifyCss()
  .pipe rename("#{config.cssFileName}.min.css")
  .pipe gulp.dest( dest.css )

  cb()

gulp.task "buildHtml", (cb)->
  dataFile = path.join process.cwd(), config.iconDataPath
  icons = JSON.parse( fs.readFileSync(dataFile, "utf8") )
  cssFile = "/assets/css/#{config.cssFileName}.css?v=#{Date.now()}"
  console.log cssFile
  locals = icons: icons, cssFile: cssFile
  gulp.src(src.jadeIndex)
  .pipe plumber()
  .pipe jade
    locals: locals
    pretty: true
  .pipe gulp.dest(dest.html)
  .pipe connect.reload()

  cb()

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



gulp.task "js", ["buildJs", "minifyJs"]
gulp.task "css", ["buildCss"]
gulp.task "html", ["buildHtml"]
gulp.task "init", ["buildSpriteData"]


gulp.task "watchImages", (cb)->
  setTimeout (->
    watch({glob: "#{iconImagePath}**", read: false, emitOnGlob: false}, ["buildImageData"])
  ), 200
  cb()

gulp.task "watchFileData", (cb)->
  setTimeout (->
    watch(glob: "data/**/*", emitOnGlob: false, ["buildSprites"])
  ), 200
  cb()

gulp.task "watchCSS", (cb)->
  setTimeout (->
    watch(glob: ["assets/css/**"], emitOnGlob: false, ["reloadServer"])
  ), 200
  cb()

gulp.task "build", ["buildImageData"]


gulp.task "watch", (cb)->
  runSequence(
    "watchImages","watchFileData", "server", "watchCSS", cb
  )

  setTimeout (->
    gulp.start("buildImageData")
  ), 500

