wd = require("wd")
Q = require("q")
request = require("request")
async = require('async')

host = "ondemand.saucelabs.com"
port = 80
username = process.env.SAUCE_USERNAME
accessKey = process.env.SAUCE_ACCESS_KEY

browser = wd.promiseRemote(host, port, username, accessKey)

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

OSX10_8 = 'OS X 10.8'
OSX10_6 = 'OS X 10.6'
WIN7 = 'Windows 7'
WINXP = 'Windows XP'
WIN8 = 'Windows 8'
LINUX = 'Linux'

browsers = {
  'android|4': [LINUX]
  'android|4|tablet': [LINUX]
  iphone: [OSX10_8]
  ipad: [OSX10_8]
  'internet explorer|10': [WIN8]
  'internet explorer|9': [WIN7]
  'firefox|21': [WIN8,WIN7,WINXP,LINUX,OSX10_6]
  'opera|12': [WIN7,WINXP,LINUX]
  'safari|5': [WIN7,OSX10_6]
  'safari|6': [OSX10_8]
  chrome: [WIN7,WINXP,LINUX,OSX10_6]
}

fns = []

for bw, platforms of browsers
  do (bw, platforms) ->
    [bw,version,deviceType] = bw.split('|')
    platforms.forEach (platform) ->
      fns.push (callback)->
        console.log bw+" - "+platform
        opts =
          browserName: bw
          platform: platform
          name: "MUI - Modern User Interfaces"
          build: process.env.TRAVIS_BUILD_NUMBER
        if deviceType
          opts.deviceType = deviceType
        if version
          opts.version = version
        browser.init(opts).then(->
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

          data =
            passed: passed
            "custom-data":
              test: results

          api ["/v1/", username, "/jobs/", browser.sessionID].join(""), "PUT", data
        ).fin(->
          browser.quit()
        ).then(->
          callback()
        ).done()

fns.push ->
  process.exit failed
async.series(fns)