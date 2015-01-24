del = require('del')

paths = require('../paths')
paths.clean = [
  path.join(paths.BASE_GENERATED_PATH, '**', '*')
]

gulp.task 'clean', -> del(paths.clean)
