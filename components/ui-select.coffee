#= require ../core/abstract

class UI.Select extends UI.Abstract
  @TAGNAME: 'select'

  _nodeRemoved: (e)->
    # Hack because the event runs before the element is removed
    if e.target.nodeType is 1
      if e.target.matchesSelector(UI.Option.SELECTOR()) and e.target.hasAttribute('selected')
        e.target.setAttribute 'disposed', true
        @selectDefault()

  _nodeAdded: (e)->
    @selectDefault() if e.target.nodeType is 1

  _select: (e)->
    return if @disabled
    return unless e.target.matchesSelector(UI.Option.SELECTOR())
    @select e.target
    @dropdown.close()

  initialize: ->
    @dropdown = @querySelector(UI.Dropdown.SELECTOR())
    @label = @querySelector(UI.Label.SELECTOR())

    @addEventListener 'DOMNodeRemoved', @_nodeRemoved
    @addEventListener 'DOMNodeInserted', @_nodeAdded
    @addEventListener UI.Events.action, @_select

    Object.defineProperty @, 'value',
      get: ->
        return null unless @selectedOption
        @selectedOption.getAttribute 'value'
      set: (value)-> @select value

    Object.defineProperty @, 'selectedOption',
      get: -> @querySelector(UI.Option.SELECTOR()+"[selected]")
      set: (value)-> @select value

    @selectDefault()

  selectDefault: ->
    selected = @querySelector(UI.Option.SELECTOR()+"[selected]:not([disposed])")
    selected ?= @querySelectorAll(UI.Option.SELECTOR()+":not([disposed])")[0]
    @select selected

  select: (value)->

    lastValue = @value

    @selectedOption?.selected = false

    if value instanceof HTMLElement
      # TODO - Child node check
      selected = value
    else
      selected = @querySelector(UI.Option.SELECTOR()+"[value='#{value}']") or null

    if selected
      selected.selected = true
      @label?.textContent = @selectedOption.textContent
    else
      @label?.textContent = ""
    @fireEvent 'change' if @value isnt lastValue
