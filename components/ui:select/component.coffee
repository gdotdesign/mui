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