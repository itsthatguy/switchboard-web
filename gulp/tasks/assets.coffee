paths = require('../paths')

paths.input.assets = [
  path.join(paths.BASE_APP_PATH, 'img', '**', '*')
  path.join(paths.BASE_APP_PATH, 'fonts', '**', '*')
  path.join(paths.BASE_APP_PATH, '**', '*.html')
]

paths.output.assets = paths.BASE_GENERATED_PATH

# Static Assets
gulp.task 'assets', ->
  gulp.src(paths.input.assets, {base: paths.BASE_APP_PATH})
    .on('error', gutil.log)
    .on('error', gutil.beep)
    .pipe(gulp.dest(paths.output.assets))
