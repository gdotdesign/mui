#= require_self
#= require_tree ./

window.XMLHttpRequest = class XMLHttpRequest
  open: ->
  getAllResponseHeaders: -> ""
  send: ->
    @readyState = 4
    @onreadystatechange.call @

Test =
  tests: {}
  assert: (condition)->
    Test.results.total++
    @steps++
    if !!condition
      @passes++
      Test.results.passed++
    else
      @fails++
      Test.results.failed++
      console.warn(@name+":"+@steps  )

  case: (name, fn)->
    context = {name: name, passes: 0, fails: 0, steps: 0, assert: @assert}
    fn.call context
    if context.fails is 0
      console.log "✔ #{name}"
    else
      console.log "✖ #{name}"
    context

  run: ->
    @results = {passed: 0, failed: 0, total: 0, runtime: 0}
    for name, test of @tests
      if console.group
        console.group(name)
      else
        console.log(name)
      test.call @
      if console.group
        console.groupEnd()
    window.results = @results
    console.log JSON.stringify(@results)

  add: (name, fn)->
    @tests[name] = fn

UI.initialize()
window.addEventListener 'load', ->
  Test.run()
  document.querySelector('.container').style.display = "block"
  pager = document.querySelector(UI.Pager.SELECTOR())

  document.addEventListener 'click', (e)->
    return unless e.target.hasAttribute('target')
    target = e.target.getAttribute('target')
    pager.change target