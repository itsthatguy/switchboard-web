// Gulpfile.js
// Require the needed packages
var gulp       = require('gulp');
var gutil      = require('gulp-util');
var clean      = require('gulp-clean');
var stylus     = require('gulp-stylus');
var browserify = require('gulp-browserify');
var rename     = require('gulp-rename');
var livereload = require('gulp-livereload');

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

var testFiles = [
  '.generated/js/app.js',
  'test/client/*.js'
];


gulp.task('test', function() {
  // Be sure to return the stream
  return gulp.src(testFiles)
    .pipe(karma({
      configFile: 'karma.conf.js',
      action: 'run'
    }))
    .on('error', function(err) {
      // Make sure failed tests cause gulp to exit non-zero
      throw err;
    });
});


gulp.task('default', function () {
  console.log("default task does nothing, hombre.")
});


//
// Stylus
//


// Get and render all .styl files recursively
gulp.task('stylus', function () {
  gulp.src(paths.cssInput)
    .pipe(stylus()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.cssOutput))
    .pipe(livereload());
});


//
// Coffee
//

gulp.task('coffee', function() {
  gulp.src(paths.coffeeInput, { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    })
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename('main.js'))
    .pipe(gulp.dest(paths.coffeeOutput))

  gulp.src('./app/js/app.coffee', { read: false })
    .pipe(browserify({
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }).on('error', gutil.log).on('error', gutil.beep))
    .pipe(rename('app.js'))
    .pipe(gulp.dest(paths.coffeeOutput))
});


//
// Static Assets
//

gulp.task('assets', function() {
  gulp.src(paths.assetsPaths, {base: paths.assetsBasePath})
    .on('error', gutil.log)
    .on('error', gutil.beep)
    .pipe(gulp.dest(paths.assetsOutput));
});

//
// Clean
//

gulp.task('clean', function() {
  gulp.src('./.generated/**/*', {read: false})
    .pipe(clean());
});


//
// Watch
//
gulp.task('watch', ['clean','stylus','coffee','assets'], function() {
  gulp.watch(paths.cssPath, ['stylus']);
  gulp.watch(paths.coffeePath, ['coffee']);
  gulp.watch(paths.assetsPaths, ['assets']);
});

gulp.task('default', ['stylus', 'coffee', 'assets']);
