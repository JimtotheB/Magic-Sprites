// Generated by CoffeeScript 1.7.1
(function() {
  var PLUGIN_NAME, PluginError, fileLogger, fs, gutil, path, stripFilename, through;

  path = require("path");

  gutil = require("gulp-util");

  PluginError = gutil.PluginError;

  through = require("through2");

  fs = require("fs");

  PLUGIN_NAME = "gulp-filelogger";

  stripFilename = function(p) {
    var extname;
    extname = path.extname(p);
    return path.basename(p, extname);
  };

  fileLogger = function(log) {
    var stream;
    stream = through.obj(function(file, enc, cb) {
      console.log(file.path);
      if (log) {
        console.log(log);
      }
      this.push(file);
      return cb();
    });
    return stream;
  };

  module.exports = fileLogger;

}).call(this);

//# sourceMappingURL=index.map
