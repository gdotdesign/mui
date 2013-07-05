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
  color:
    value: "#f00"
    disabled: false
  modal:
    target: -> document.querySelector('ui-modal')
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
  toggle:
    checked: true
    disabled: false
    toggle: ->
  tooltip:
    label: 'Tooltip'
    direction: ['bottom', 'top', 'left', 'right']
    disabled: false
    open: ->
    close: ->
    toggle: ->
  textarea:
    placeholder: 'Textarea...'
    value: ''
    disabled: false

UI.initialize()

window.addEventListener 'load', ->
  Test.run()

  for code in document.querySelectorAll('code')
    code.innerHTML = code.innerHTML.trim()

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
      p = document.querySelector("ui-page[name=#{name}]")
      page = document.querySelector("ui-page[name=#{name}] section")
      dl = document.createElement('dl')
      code = document.createElement('code')
      code.classList.add 'html'
      p.appendChild dl
      if controls.target
        element = controls.target()
        delete controls.target
      else
        element = page.querySelector("ui-#{name}")
      for key, value of controls
        do (key, value) ->
          dt = document.createElement 'dt'
          label = UI.Label.create()
          label.textContent = key
          dt.appendChild label
          dd = document.createElement 'dd'
          if value instanceof Function
            btn = UI.Button.create()
            btn.label = key
            btn.type = "info"
            btn.addEventListener UI.Events.action, (e)->
              e.stopPropagation()
              element[key]()
            dd.appendChild btn
          else if typeof value is 'boolean'
            toggle = UI.Toggle.create()
            toggle.value = element[key] = value
            element.addEventListener 'change', ->
              toggle.value = element[key]
            toggle.addEventListener 'change', ->
              element[key] = toggle.value
            dd.appendChild toggle
          else if typeof value is 'string'
            input = UI.Text.create()
            input.value = value
            element[key] = value
            input.addEventListener 'input', ->
              element[key] = input.value
            dd.appendChild input
          else if value.length
            select = UI.Select.create()
            for item in value
              select.dropdown.appendChild UI.Option.create(item)
            select.addEventListener 'change', ->
              element[key] = select.value
            dd.appendChild select
          dl.appendChild dt
          dl.appendChild dd

hljs.tabReplace = '    '
hljs.initHighlightingOnLoad()