wd = require("wd")
Q = require("q")
request = require("request")
assert = require("assert")
host = "ondemand.saucelabs.com"
port = 80
username = process.env.SAUCE_USERNAME
accessKey = process.env.SAUCE_ACCESS_KEY

browser = wd.promiseRemote(host, port, username, accessKey)
browser.on "status", (info) ->
  console.log "\u001b[36m%s\u001b[0m", info

browser.on "command", (meth, path, data) ->
  console.log " > \u001b[33m%s\u001b[0m: %s", meth, path, data or ""

api = (url, method, data) ->
  deferred = Q.defer()
  request
    method: method
    uri: ["https://", username, ":", accessKey, "@saucelabs.com/rest", url].join("")
    headers:
      "Content-Type": "application/json"

    body: JSON.stringify(data)
  , (error, response, body) ->
    deferred.resolve response.body

  deferred.promise

failed = 0

browser.init(
  browserName: "chrome"
  name: "MUI"
  build: process.env.TRAVIS_BUILD_NUMBER
).then(->
  browser.get("http://mui-test.herokuapp.com/specs/").delay 3000
).then(->
  browser.eval "window.results"
).then((results) ->
  unless results
    passed = false
    failed = 1
  else
    passed = results.failed is 0
    failed = 1 unless passed
  data = "custom-data":
    test: results
    passed: passed

  api ["/v1/", username, "/jobs/", browser.sessionID].join(""), "PUT", data
).then((body) ->
  console.log "CONGRATS - WE'RE DONE", body
).fin(->
  browser.quit()
).done()