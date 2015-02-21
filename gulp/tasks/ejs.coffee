ejs = require("gulp-ejs")

paths.input.ejs = path.join(paths.BASE_APP_PATH, '**', '*.ejs')

# EJS
gulp.task 'ejs', ->
  gulp.src(paths.input.ejs)
    .pipe(plumber())
    .pipe(ejs())
    .pipe(gulp.dest(paths.BASE_GENERATED_PATH))
