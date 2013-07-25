#= require_self
#= require_tree ./

# Replace XMLHTTPRequest for test
window.XMLHttpRequest = class XMLHttpRequest
  open: ->
  getAllResponseHeaders: -> ""
  send: ->
    @readyState = 4
    @onreadystatechange.call @

# Test "framework"
Test =
  spyOn: (object,method)->
    oldMethod = object[method]
    object[method] = (args...) ->
      object[method].calls+++
      oldMethod.apply object, args
    object[method].calls = 0
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

# Controls for kitchen sink
Controls =
  context:
    open: ->
    close: ->
    target: -> document.querySelector('ui-context')
  dropdown:
    direction: ['bottom','top','left','right']
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
  text:
    placeholder: 'Text...'
    value: ''
    disabled: false
  number:
    placeholder: 'Number...'
    value: ''
    disabled: false
  textarea:
    placeholder: 'Textarea...'
    value: ''
    disabled: false
  email:
    placeholder: 'Email...'
    value: ''
    disabled: false
  radio:
    checked: true
    disabled: false
    toggle: ->
  range:
    min: -100
    max: 100
    value: 0
    disabled: false
  slider:
    min: -100
    max: 100
    value: 0
    disabled: false
  select:
    value: ['option1', 'option2', 'option4']
    disabled: false
  pager:
    next: ->
    prev: ->
    activePage: ['page1','page2']
  grid:
    columns: 3
  form:
    action: '/upload'
    method: ['post','put','get','patch','delete']
    submit: ->
  popover:
    direction: ['bottom','top','left','right']
    open: ->
    close: ->
    toggle: ->
    disabled: false

hljs.tabReplace = '    '
hljs.initHighlightingOnLoad()

window.addEventListener 'load', ->
  setTimeout =>
    window.startElementCount = 0
    for el in document.querySelectorAll("*")
      startElementCount++ if el.tagName.match /ui-/i
    Test.run()

    # Show action - method - data on submit
    form = document.querySelector('ui-form')
    form.addEventListener 'submit', (e)->
      e.preventDefault()
      data = "#{@method.toUpperCase()}::#{@action} -> #{JSON.stringify(@data)}"
      alert(data)

    # Trim ends for code highlight
    for code in document.querySelectorAll('code')
      code.innerHTML = code.innerHTML.trim()

    document.querySelector('.container').style.display = "block"
    @pager = document.querySelector(UI.Pager.SELECTOR())

    change = ->
      target = @location.hash[1..]
      return unless target
      @pager.change target
      document.querySelector('[target].active').classList.remove 'active'
      document.querySelector("[target=#{target}]").classList.add 'active'

    document.addEventListener 'focus', (e)->
      pg = getParent(e.target,UI.Page.SELECTOR())
      return unless pg
      window.location.hash = pg.getAttribute('name')
    ,true

    @addEventListener 'hashchange', ->
      change()

    change()

    document.addEventListener 'click', (e)->
      return unless e.target.hasAttribute('target')
      @location.hash = e.target.getAttribute('target')

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
            else if typeof value is 'string' or typeof value is 'number'
              input = UI.Text.create()
              input.value = value
              element[key] = value
              if key is 'value'
                element.addEventListener 'input', ->
                  input.value = element[key]
                element.addEventListener 'change', ->
                  input.value = element[key]
              input.addEventListener 'input', ->
                element[key] = input.value
              dd.appendChild input
            else if value.length
              select = UI.Select.create()
              for item in value
                select.dropdown.appendChild UI.Option.promise({value: item}, [item])()
              select.addEventListener 'change', ->
                element[key] = select.value
              if key is 'activePage'
                element.addEventListener 'change', ->
                  select.value = element[key].getAttribute('name')
              if key is 'value'
                element.addEventListener 'change', ->
                  select.value = element[key]
              dd.appendChild select
            dl.appendChild dt
            dl.appendChild dd
  , 1000
