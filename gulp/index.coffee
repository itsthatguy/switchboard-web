global.gulp    = require("gulp")
global.gutil   = require("gulp-util")
global.plumber = require("gulp-plumber")
global.paths   = require("./paths")
runSequence    = require("run-sequence")

cleanTask    = require("./tasks/clean")
testTask     = require("./tasks/test")
cssTask      = require("./tasks/css")
ejsTask      = require("./tasks/ejs")
jsTask       = require("./tasks/js")
assetsTask   = require("./tasks/assets")
serverTask   = require("./tasks/server")
watchTask    = require("./tasks/watch")

gulp.task "default", (callback) ->
  runSequence "clean", "ejs", "css", "js", "assets", callback
