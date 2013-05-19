class UI.Select extends UI.Abstract
  @TAGNAME: 'select'

  initialize: ->
    @_dropdown = @querySelector(UI.Dropdown.SELECTOR())
    @_label = @querySelector(UI.Label.SELECTOR())

    UI.warn('SELECT: No dropdown found...') unless @_dropdown
    UI.warn('SELECT: No label found...') unless @_label

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
        @_dropdown.close()
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
      @_label?.textContent = @selectedOption.textContent
    else
      @_label?.textContent = ""
      @value = null
    if @value isnt lastValue
      UI.log 'SELECT: change'
      @fireEvent('change')