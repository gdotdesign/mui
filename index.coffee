qs = (args...)-> document.querySelector.apply document, args

UI = {
  verbose: true
  ns: 'ui'
  log: (args...)->
    if @verbose
      log.apply window, args
}

class UI.Abstract
  @SELECTOR: -> UI.ns+"\\:"+@TAGNAME
  @wrap: (el)->
    for key, fn of @::
      if key isnt 'initialize'
        el[key] = fn.bind(el)
    @::initialize?.call el
    @_processed = true

  fireEvent: (type,data)->
    event = document.createEvent("HTMLEvents")
    event.initEvent(type, true, true)
    for key, value of data
      event[key] = value
    @dispatchEvent(event)
    event

class UI.Select extends UI.Abstract
  @TAGNAME: 'select'

  initialize: ->
    @addEventListener 'click', (e)=>
      if e.target.matchesSelector(UI.Option.SELECTOR())
        @select(e.target)
        @querySelector(UI.Dropdown.SELECTOR()).style.display = 'none'
      else
        @querySelector(UI.Dropdown.SELECTOR()).style.display = 'block'
    @selectDefault()

  selectDefault: ->
    selected = @querySelector(UI.Option.SELECTOR()+"[selected]")
    selected ?= @querySelector(UI.Option.SELECTOR()+":first-of-type")
    if selected
      @select(selected)

  select: (value)->
    if value instanceof HTMLElement
      @selectedOption = value
    else
      option = @querySelector(UI.Option.SELECTOR()+"[value='#{value}']")
      @selectedOption = option or null
    @_setValue()

  _setValue: ->
    if @selectedOption
      @querySelector('[selected]')?.removeAttribute('selected')
      @selectedOption.setAttribute('selected',true)
      @value = @selectedOption.getAttribute('value')
      @querySelector(UI.Label.SELECTOR())?.textContent = @selectedOption.textContent

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

class UI.Checkbox extends UI.Abstract
  @TAGNAME: 'checkbox'

  initialize: ->
    @addEventListener 'click', =>
      if @getAttribute('checked') isnt null
        @removeAttribute('checked')
      else
        @setAttribute('checked',true)

class UI.Dropdown extends UI.Abstract
  @TAGNAME: 'dropdown'

  initialize: ->
    document.addEventListener 'click', (e)=>
      if e.target isnt @
        @style.display = 'none'
    , true

class UI.Input extends UI.Abstract
  @TAGNAME: 'input'
  initialize: ->
    @setAttribute('contenteditable',true)
    @_input = document.createElement('input')
    @addEventListener 'input', (e) ->
      @value = @textContent
    @addEventListener 'blur', (e) ->
      if @childNodes.length is 1
        if @childNodes[0].tagName is 'BR'
          @removeChild @childNodes[0]

class UI.Textarea extends UI.Input
  @TAGNAME: 'textarea'

class UI.Text extends UI.Input
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

getParent = (el,tagName)->
  if el.parentNode
    if el.parentNode.tagName is tagName.toUpperCase()
      el.parentNode
    else
      getParent(el.parentNode,tagName)
  else
    null

class UI.Submit extends UI.Abstract
  @TAGNAME: 'submit'
  initialize: ->
    @addEventListener 'click', ->
      form = getParent(@,'ui:form')
      if form
        form.submit()

init = (e)->
  return unless e.target.tagName
  return if e.target._processed
  tagName = e.target.tagName
  if tagName.match /^UI:/
    tag = tagName.split(":").pop().toLowerCase().replace /^\w|\s\w/g, (match) ->  match.toUpperCase()
    if UI[tag]
      UI[tag].wrap e.target

document.addEventListener 'DOMNodeInserted', init

for key, value of UI
  if value.SELECTOR
    for el in document.querySelectorAll(value.SELECTOR())
      value.wrap el