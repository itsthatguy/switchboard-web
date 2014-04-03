// Gulpfile.js
// Require the needed packages
var gulp = require('gulp');
var stylus = require('gulp-stylus');

var paths = {
  cssPath: ['./app/css/**/*.styl'],
  cssOutput: './app/css/main.styl'
};

// Get one .styl file and render
gulp.task('default', function () {
  console.log("default task does nothing, hombre.")
});

// Get and render all .styl files recursively
gulp.task('stylus', function () {
  gulp.src(paths.cssOutput)
    .pipe(stylus())
    .pipe(gulp.dest('./.generated/css'));
});

gulp.task('watch', function() {
  gulp.watch(paths.cssPath, ['stylus']);
});

gulp.task('default', ['stylus']);
