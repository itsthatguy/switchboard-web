runCommand = require("run-command")

runCommand "bower", ['install'], ->
  runCommand "gulp"
