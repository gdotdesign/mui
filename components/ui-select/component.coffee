#= require ../../core/abstract

class UI.Select extends UI.Abstract
  @TAGNAME: 'select'

  initialize: ->
    @_dropdown = @querySelector(UI.Dropdown.SELECTOR())
    @_label = @querySelector(UI.Label.SELECTOR())

    UI.warn('SELECT: No dropdown found!') unless @_dropdown
    UI.warn('SELECT: No label found!') unless @_label

    Object.defineProperty @, 'value',
      get: ->
        return null unless @selectedOption
        @selectedOption.getAttribute('value')
      set: (value)-> @select(value)

    Object.defineProperty @, 'selectedOption',
      get: ->
        @querySelector(UI.Option.SELECTOR()+"[selected]")
      set: (value)-> @select(value)

    @addEventListener 'DOMNodeRemoved', (e)=>
      # Hack because the event runs before the element is removed
      if e.target.nodeType is 1
        if e.target.matchesSelector(UI.Option.SELECTOR())
          if e.target.hasAttribute('selected')
            e.target.setAttribute('disposed',true)
            @selectDefault()
    @addEventListener 'DOMNodeInserted', (e)=>
      @selectDefault() if e.target.nodeType is 1

    @addEventListener 'click', (e)=>
      return if @disabled
      if e.target.matchesSelector(UI.Option.SELECTOR())
        @select(e.target)
        @_dropdown.close()

    @selectDefault()

  selectDefault: ->
    UI.log 'SELECT: selectDefault'
    selected = @querySelector(UI.Option.SELECTOR()+"[selected]:not([disposed])")
    selected ?= @querySelectorAll(UI.Option.SELECTOR()+":not([disposed])")[0]
    @select(selected)

  select: (value)->
    UI.log 'SELECT: select', value

    lastValue = @value

    selected = if value instanceof HTMLElement
      value
    else
      @querySelector(UI.Option.SELECTOR()+"[value='#{value}']") or null

    @querySelector('[selected]')?.removeAttribute('selected')
    if selected
      selected.setAttribute('selected',true)
      @_label?.textContent = selected.textContent
    else
      @_label?.textContent = ""
    if @value isnt lastValue
      UI.log 'SELECT: change'
      @fireEvent('change')