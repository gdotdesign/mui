qs = (args...)-> document.querySelector.apply document, args

UI = {
  verbose: true
  ns: 'ui'
  warn: (text)->
    console.warn text
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

  @create: ->
    base = document.createElement(UI.ns+":"+@TAGNAME)
    if @::initialize
      @wrap base
    base

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
    @dropdown = @querySelector(UI.Dropdown.SELECTOR())
    @label = @querySelector(UI.Label.SELECTOR())

    UI.warn('SELECT: No dropdown found...') unless @dropdown
    UI.warn('SELECT: No label found...') unless @label

    @addEventListener 'DOMNodeRemoved', (e)=>
      setTimeout =>
        if e.target is @selectedOption
          @selectDefault()
    @addEventListener 'DOMNodeInserted', (e)=>
      if e.target.nodeType is 1
        @selectDefault()

    @addEventListener 'click', (e)=>
      return if @getAttribute('disabled')
      if e.target.matchesSelector(UI.Option.SELECTOR())
        @select(e.target)
    @selectDefault()

  selectDefault: ->
    UI.log 'SELECT: selectDefault'
    selected = @querySelector(UI.Option.SELECTOR()+"[selected]")
    selected ?= @querySelector(UI.Option.SELECTOR()+":first-of-type")
    @select(selected)

  select: (value)->
    UI.log 'SELECT: select', value
    return if @selectedOption is value
    if value instanceof HTMLElement
      @selectedOption = value
    else
      option = @querySelector(UI.Option.SELECTOR()+"[value='#{value}']")
      @selectedOption = option or null
    @_setValue()

  _setValue: ->
    UI.log('SELECT: setValue')
    lastValue = @value
    if @selectedOption
      @querySelector('[selected]')?.removeAttribute('selected')
      @selectedOption.setAttribute('selected',true)
      @value = @selectedOption.getAttribute('value')
      @label?.textContent = @selectedOption.textContent
    else
      @label?.textContent = ""
      @value = null
    if @value isnt lastValue
      UI.log 'SELECT: change'
      @fireEvent('change')

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
  @wrap: (el)->
    super
    Object.defineProperty el, 'checked',
      get: ->  @hasAttribute('checked')
      set: (value)->
        if value
          @setAttribute('checked',true)
        else
          @removeAttribute('checked')
        @fireEvent('change')

  initialize: ->
    @addEventListener 'click', =>
      if @hasAttribute('checked')
        @removeAttribute('checked')
      else
        @setAttribute('checked',true)
      @fireEvent('change')

class UI.Dropdown extends UI.Abstract
  @TAGNAME: 'dropdown'

  onAdded: ->
    console.log('onAdded')
    @parentNode.addEventListener 'click', @toggle

  toggle: ->
    @_open = !@_open
    if @_open
      @removeAttribute('open')
    else
      @setAttribute('open',true)

  initialize: ->
    @_open = true
    @onAdded() if @parentNode
    document.addEventListener 'click', (e)=>
      if e.target isnt @
        @removeAttribute('open')
    , true

class UI.Input extends UI.Abstract
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

class UI.Pager extends UI.Abstract
  @TAGNAME: 'pager'
  select: (value)->
    UI.log 'PAGER: select', value
    return if @selectedPage is value
    if value instanceof HTMLElement
      @selectedPage = value
    else
      @selectedPage = @querySelector("[name=#{value}]")
    return unless @selectedPage
    @querySelector('[active]')?.removeAttribute('active')
    @selectedPage.setAttribute('active',true)

Element::toggleAttribute = (attr) ->
  if @hasAttribute(attr)
    @removeAttribute(attr)
  else
    @setAttribute(attr,'true')


# CUSTOM ELEMENTS
#################
class UI.ListItem extends UI.Abstract
  @TAGNAME: 'listitem'

  initialize: ->
    @addEventListener 'change', (e)->
      @toggleAttribute('done')

  @create: (options)->
    base = super
    label = UI.Text.create()
    checkbox = UI.Checkbox.create()

    base.appendChild(label)
    base.appendChild(checkbox)

    if options.label
      label.textContent = options.label
    if options.done
      checkbox.checked = true
      base.setAttribute('done', true)

    base

init = (e)->
  return unless e.target.tagName
  return if e.target._processed
  tagName = e.target.tagName
  if tagName.match /^UI:/
    tag = tagName.split(":").pop().toLowerCase().replace /^\w|\s\w/g, (match) ->  match.toUpperCase()
    if UI[tag]
      UI[tag].wrap e.target
      e.target.onAdded?()

document.addEventListener 'DOMNodeInserted', init

window.addEventListener 'load', ->
  for key, value of UI
    if value.SELECTOR
      for el in document.querySelectorAll(value.SELECTOR())
        value.wrap el