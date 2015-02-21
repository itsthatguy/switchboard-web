serverFile = path.join(paths.ROOT_PATH, 'lib', 'switchboard')

coffee = require('coffee-script/register')
server = require(serverFile)

gulp.task 'server', ['watch'], -> server()
