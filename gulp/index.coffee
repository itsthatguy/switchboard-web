global.gulp    = require('gulp')
global.gutil   = require('gulp-util')
global.plumber = require('gulp-plumber')

paths        = require('./paths')

cleanTask    = require('./tasks/clean')
testTask     = require('./tasks/test')
cssTask      = require('./tasks/css')
ejsTask      = require('./tasks/ejs')
jsTask       = require('./tasks/js')
assetsTask   = require('./tasks/assets')
watchTask    = require('./tasks/watch')

gulp.task 'default', ->
  console.log("default task does nothing, hombre.")

gulp.task 'default', ['css', 'js', 'assets']
