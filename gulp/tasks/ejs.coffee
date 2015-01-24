ejs = require("gulp-ejs")

paths = require('../paths')

paths.input.ejs = path.join(paths.BASE_APP_PATH, '**', '*.ejs')

# EJS
gulp.task 'ejs', ->
  gulp.src(paths.input.ejs)
    .pipe(ejs()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.BASE_GENERATED_PATH))
