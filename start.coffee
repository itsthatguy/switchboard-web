dotenv     = require('dotenv')
runCommand = require("run-command")

dotenv.load()

console.log(">> NODE_ENV: " + process.env.NODE_ENV)

runCommand("coffee", ['index.coffee'])

if (process.env.NODE_ENV == "development")
  runCommand "gulp", ['watch-pre-tasks'], ->
    runCommand("gulp", ['watch'])
