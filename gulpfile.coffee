# Generic gulp tools
gulp = require "gulp"
jade = require "gulp-jade"
gutil = require "gulp-util"
watch = require "gulp-watch"
plumber = require "gulp-plumber"
rename = require "gulp-rename"
gulpif = require "gulp-if"
debug = require "gulp-debug"

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

buildIcons = require "./plugins/gulp-buildIcons"
buildData = require "./plugins/gulp-getFilenames"

# Outside config
config = require("./config.json")
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

gulp.task "buildSpriteData", ->
  gulp.src(iconImagePath)
  .pipe plumber()
  .pipe buildData()

gulp.task "buildSprites", (cb)->
  gulp.src(iconImagePath)
  .pipe plumber()
  .pipe sprite
#    name: "sprite.png"
    style: "sprites.less"
    base64: true
    cssPath: dest.images
    processor: "less"
  .pipe gulpif("*.png", gulp.dest(dest.images))
  .pipe gulpif("*.less",buildIcons(dataFile: config.iconDataPath, fileName: "#{config.cssFileName}.less"))
  .pipe gulp.dest("./build/less")

  cb()


gulp.task "buildCss", ->
  gulp.src( src.less )
  .pipe plumber()
  .pipe less()
#  .pipe rename("#{config.cssFileName}.css")
#  .pipe gulp.dest( dest.css )
  .pipe minifyCss()
  .pipe rename("#{config.cssFileName}.min.css")
  .pipe gulp.dest( dest.css )

gulp.task "buildHtml", (cb)->
  icons = require config.iconDataPath
  locals = icons: icons, cssFile: config.cssFileName
  gulp.src(src.jadeIndex)
  .pipe plumber()
  .pipe jade
    locals: locals
    pretty: true
  .pipe gulp.dest(dest.html)

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

gulp.task "reloadServer", ["buildHtml"],->
  gulp.src src.html
  .pipe connect.reload()


gulp.task "runWatch", ["server"],->
  css =   ["buildCss"]
  js =    ["buildJs", "minifyJs"]
  reload = ["reloadServer"]
  rebuild = ["buildCss"]
  gulp.watch("./build/**/*.less", css )
  gulp.watch(src.jade, reload)
  gulp.watch(src.coffee, js)
#  gulp.watch("./assets/css/*.css", reload)

  gulp.watch("./*.json", rebuild)
  gulp.watch("./assets/css/**/*.css", reload)


gulp.task "js", ["buildJs", "minifyJs"]
gulp.task "css", ["buildCss"]
gulp.task "html", ["buildHtml"]
gulp.task "watch", ["runWatch"]
gulp.task "init", ["buildSpriteData"]
gulp.task "build", ["buildSprites"]


