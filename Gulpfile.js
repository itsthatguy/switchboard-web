// Gulpfile.js
// Require the needed packages
var gulp = require('gulp');
var stylus = require('gulp-stylus');
var browserify = require('gulp-browserify');
var rename = require('gulp-rename');

var paths = {
  cssPath: ['./app/css/**/*.styl*'],
  cssInput: './app/css/main.styl',
  cssOutput: './.generated/css',
  coffeePath: ['./app/js/**/*.coffee'],
  coffeeInput: './app/js/main.coffee',
  coffeeOutput: './.generated/js',
  assetsBasePath: './app',
  assetsPaths: [
    './app/img/**/*',
    './app/fonts/**/*'
  ],
  assetsOutput: './.generated/'
};


gulp.task('default', function () {
  console.log("default task does nothing, hombre.")
});


//
// Stylus
//


// Get and render all .styl files recursively
gulp.task('stylus', function () {
  gulp.src(paths.cssInput)
    .pipe(stylus())
    .pipe(gulp.dest(paths.cssOutput));
});


//
// Coffee
//

gulp.task('coffee', function() {
  gulp.src(paths.coffeeInput, { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe(rename('main.js'))
    .pipe(gulp.dest(paths.coffeeOutput))
});


//
// Static Assets
//

gulp.task('assets', function() {
  gulp.src(paths.assetsPaths, {base: paths.assetsBasePath})
    .pipe(gulp.dest(paths.assetsOutput));
});


//
// Watch
//
gulp.task('watch', function() {
  gulp.watch(paths.cssPath, ['stylus']);
  gulp.watch(paths.coffeePath, ['coffee']);
  gulp.watch(paths.assetsPaths, ['assets']);
});

gulp.task('default', ['stylus', 'coffee', 'assets']);
