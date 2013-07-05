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

Controls =
  dropdown:
    direction: ['bottom','top']
    open: ->
    close: ->
    toggle: ->
    disabled: false
  button:
    type: ['default','info','success','warning','danger','inverse']
    label: 'Button'
    disabled: false
  checkbox:
    checked: true
    disabled: false
    toggle: ->
  tooltip:
    disabled: false
    open: ->
    close: ->
    toggle: ->
    label: 'Tooltip'
    direction: ['bottom', 'top', 'left', 'right']

UI.initialize()
window.addEventListener 'load', ->
  Test.run()
  document.querySelector('.container').style.display = "block"
  pager = document.querySelector(UI.Pager.SELECTOR())

  document.addEventListener 'click', (e)->
    return unless e.target.hasAttribute('target')
    target = e.target.getAttribute('target')
    pager.change target
    document.querySelector('[target].active').classList.remove 'active'
    e.target.classList.add 'active'

  for name, controls of Controls
    do (name, controls) ->
      page = document.querySelector("ui-page[name=#{name}] section")
      element = page.querySelector("ui-#{name}")
      for key, value of controls
        do (key, value) ->
          if value instanceof Function
            btn = UI.Button.create()
            btn.label = key
            btn.type = "info"
            btn.addEventListener UI.Events.action, (e)->
              e.stopPropagation()
              element[key]()
            page.appendChild btn
          else if typeof value is 'boolean'
            toggle = UI.Toggle.create()
            toggle.value = element[key] = value
            toggle.addEventListener 'change', ->
              element[key] = toggle.value
            page.appendChild toggle
          else if typeof value is 'string'
            input = UI.Text.create()
            input.value = value
            element[key] = value
            input.addEventListener 'input', ->
              element[key] = input.value
            page.appendChild input
          else if value.length
            select = UI.Select.create()
            for item in value
              select.dropdown.appendChild UI.Option.create(item)
            select.addEventListener 'change', ->
              element[key] = select.value
            page.appendChild select




