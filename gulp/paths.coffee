global.path = require("path")

module.exports = paths =
  input  : {}
  output : {}
  watch  : {}
paths.ROOT_PATH = path.join(__dirname, '..')
paths.BASE_APP_PATH       = path.join(paths.ROOT_PATH, 'app')
paths.BASE_GENERATED_PATH = path.join(paths.ROOT_PATH, '.generated')
