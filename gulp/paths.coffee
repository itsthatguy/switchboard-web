global.path = require("path")

paths =
  input  : {}
  output : {}
  watch  : {}
paths.BASE_APP_PATH       = path.join(__dirname, '..', 'app')
paths.BASE_GENERATED_PATH = path.join(__dirname, '..', '.generated')

module.exports = paths
