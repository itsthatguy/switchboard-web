paths = require('../paths')

paths.input.test = [
  '.generated/js/app.js'
  'test/client/*.js'
]

gulp.task 'test', ->
  # Be sure to return the stream
  gulp.src(paths.input.test)
    .pipe(karma(
      configFile: 'karma.conf.js',
      action: 'run' ))
    .on 'error', (err) -> throw err
