browserify = require('browserify')
buffer     = require('vinyl-buffer')
rename     = require('gulp-rename')
source     = require('vinyl-source-stream')
sourcemaps = require('gulp-sourcemaps')
uglify     = require('gulp-uglify')

paths = require('../paths')

paths.input.js =
  vendor : []
  src    : path.join(paths.BASE_APP_PATH, 'js', 'app.coffee')
paths.output.js = path.join(paths.BASE_GENERATED_PATH, 'js')

# Task
gulp.task 'js', ->
  jsStream = browserify(paths.input.js.src, {
    extensions: ['.coffee']
    debug: true
  }).require(paths.input.js.vendor)
    .transform('coffeeify')
    .bundle()
    .on('error', gutil.log)
    .on('error', gutil.beep)

  # standard code
  jsStream
    .pipe(plumber())
    .pipe(source(paths.input.js.src[0]))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(rename('app.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(paths.output.js))

  # minified code
  jsStream
    .pipe(plumber())
    .pipe(source(paths.input.js.src[0]))
    .pipe(buffer())
    .pipe(sourcemaps.init({loadMaps: true}))
    .pipe(uglify({ compress: { negate_iife: false }})
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename('peteshow.min.js'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(paths.output.js))

  return jsStream
