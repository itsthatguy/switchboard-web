paths = require('../paths')

paths.watch =
  css : [path.join(paths.BASE_APP_PATH, 'css', '**', '*.styl*')]
  js  : [path.join(paths.BASE_APP_PATH, 'js', '**', '*.styl*')]

# Watch
gulp.task 'watch', ['default'], ->
  gulp.watch(paths.watch.css, ['css'])
  gulp.watch(paths.watch.js, ['js'])
  gulp.watch(paths.watch.assets, ['assets'])
  gulp.watch(paths.watch.ejs, ['ejs'])

  if (process.env.ENVIRONMENT != "PRODUCTION")
    livereload = require('gulp-livereload')
    server = livereload()

    gulp.watch(path.join(paths.BASE_GENERATED_PATH, '**'))
      .on 'change', (file) -> server.changed(file.path)
