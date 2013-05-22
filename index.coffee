window.console ?=
  log: ->
  warn: ->

UI =
  verbose: false
  ns: 'ui'
  warn: (text)->
    console.warn text
  log: (args...)->
    if UI.verbose
      console.log.apply console, args
  onInsert: (e)->
    return unless e.target.tagName
    tagName = e.target.tagName
    if tagName.match /^UI-/
      tag = tagName.split("-").pop().toLowerCase().replace /^\w|\s\w/g, (match) ->  match.toUpperCase()
      if UI[tag]
        unless e.target._processed
          UI[tag].wrap e.target
        else
          e.target.onAdded?()
  load: ->
    for key, value of UI
      if value.SELECTOR
        for el in document.querySelectorAll(value.SELECTOR())
          value.wrap el
  initialize: ->
    document.addEventListener 'DOMNodeInserted', UI.onInsert
    window.addEventListener 'load', UI.load

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

  add: (name, fn)->
    @tests[name] = fn

Element::toggleAttribute = (attr, value) ->
  state = !@hasAttribute(attr)
  if value isnt undefined
    state = !!value
  if state
    @setAttribute(attr,'true')
  else
    @removeAttribute(attr)

getParent = (el,tagName)->
  return el if el.tagName is tagName.toUpperCase()
  if el.parentNode
    if el.parentNode.tagName is tagName.toUpperCase()
      el.parentNode
    else
      getParent(el.parentNode,tagName)
  else
    null

class UI.Abstract
  @SELECTOR: -> UI.ns+"-"+@TAGNAME
  @wrap: (el)->
    for key, fn of @::
      if key isnt 'initialize'
        el[key] = fn.bind(el)
    el._processed = true
    @::initialize?.call el

    Object.defineProperty el, 'disabled',
      get: -> @hasAttribute('disabled')
      set: (value) ->
        value = !!value
        if value
          @setAttribute('disabled',true)
        else
          @removeAttribute('disabled')

    el.onAdded?() if el.parentNode

  @create: ->
    base = document.createElement(@SELECTOR())
    @wrap base
    base

  fireEvent: (type,data)->
    event = document.createEvent("HTMLEvents")
    event.initEvent(type, true, true)
    for key, value of data
      event[key] = value
    @dispatchEvent(event)
    event

  toString: ->
    "<#{@tagName.toLowerCase()}>"

class UI.iOpenable extends UI.Abstract
  onAdded: ->
    if getComputedStyle(@parentNode).position is 'static'
      @parentNode.style.position = 'relative'

  open:   -> @setAttribute('open',true)
  close:  -> @removeAttribute('open')
  toggle: -> @toggleAttribute('open')

  initialize: (directions = [])->
    Object.defineProperty @, 'isOpen', get: -> @hasAttribute('open')
    Object.defineProperty @, 'direction',
      get: ->
        dir = @getAttribute('direction')
        dir = 'bottom' if directions.indexOf(dir) is -1
        dir
      set: (value)->
        value = 'bottom' if directions.indexOf(value) is -1
        if value is 'bottom'
          @removeAttribute('direction')
        else
          @setAttribute('direction',value)

class UI.iInput extends UI.Abstract
  @TAGNAME: 'input'
  @wrap: (el)->
    super
    Object.defineProperty el, 'value',
      get: ->  @textContent
      set: (value)-> @textContent = value

  initialize: ->
    @setAttribute('contenteditable',true)
    @_input = document.createElement('input')
    @addEventListener 'blur', (e) ->
      if @childNodes.length is 1
        if @childNodes[0].tagName is 'BR'
          @removeChild @childNodes[0]

# Move these to components
# -----------------------
class UI.Option extends UI.Abstract
  @TAGNAME: 'option'

class UI.Label extends UI.Abstract
  @TAGNAME: 'label'
  initialize: ->
    @addEventListener 'click', =>
      name = @getAttribute('for')
      el = document.querySelector("[name=#{name}]")
      el?.focus()
      el?.click()

class UI.Textarea extends UI.iInput
  @TAGNAME: 'textarea'

class UI.Text extends UI.iInput
  @TAGNAME: 'text'
  initialize: ->
    super
    @addEventListener 'keydown', (e) ->
      e.preventDefault() if e.keyCode is 13

class UI.Email extends UI.Text
  @TAGNAME: 'email'

class UI.Password extends UI.Text
  @TAGNAME: 'password'
  initialize: ->
    super
    @addEventListener 'input', (e) ->
      @setAttribute 'mask', @textContent.replace(/./g,'*')

class UI.Form extends UI.Abstract
  @TAGNAME: 'form'
  submit: ->
    event = @fireEvent('submit')
    unless event.defaultPrevented
      formData = new FormData()
      data = {}
      for el in @querySelectorAll('[name]')
        if el.value
          formData.append(el.getAttribute('name'), el.value)
          data[el.getAttribute('name')] = el.value
      UI.log('Sending request to: *'+@getAttribute('method').toUpperCase()+"* - _"+@getAttribute('action')+"_", data)
      oReq = new XMLHttpRequest()
      oReq.open("POST", "submitform.php")
      oReq.send(new FormData(formData))
      oReq.onreadystatechange = =>
        if oReq.readyState is 4
          headers = {}
          oReq.getAllResponseHeaders().split("\n").map (item) ->
            [key,value] = item.split(": ")
            if key and value
              headers[key] = value
          body = oReq.response
          status = oReq.status
          @fireEvent 'complete', {response: {headers: headers, body: body, status: status}}

class UI.Page extends UI.Abstract
  @TAGNAME: 'page'
class UI.Pager extends UI.Abstract
  @TAGNAME: 'pager'
  select: (value)->
    UI.log 'PAGER: select', value
    lastPage = @selectedPage
    return if @selectedPage is value
    if value instanceof HTMLElement
      @selectedPage = value
    else
      @selectedPage = @querySelector(UI.Page.SELECTOR()+"[name='#{value}']")
    return unless @selectedPage
    @querySelector('[active]')?.removeAttribute('active')
    @selectedPage.setAttribute('active',true)
    if lastPage isnt @selectedPage
      @fireEvent('change')