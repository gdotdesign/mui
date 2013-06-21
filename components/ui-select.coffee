#= require ../core/abstract

# Select component
class UI.Select extends UI.Abstract
  @TAGNAME: 'select'

  # @property [String] The current value of the component
  @set 'value', (value)-> @select value
  @get 'value', ->
    return null unless @selectedOption
    @selectedOption.getAttribute 'value'

  # @property [UI.Option] The currently selected option component
  @get 'selectedOption', -> @querySelector(UI.Option.SELECTOR()+"[selected]")
  @set 'selectedOption', (value)-> @select value

  # Node removed handler
  # @private
  _nodeRemoved: (e)->
    # Hack because the event runs before the element is removed
    return unless e.target.nodeType is 1
    return if not e.target.matchesSelector(UI.Option.SELECTOR()) and not e.target.hasAttribute('selected')
    e.target.setAttribute 'disposed', true
    @selectDefault()

  # Node added handler
  # @private
  _nodeAdded: (e)->
    @selectDefault() if e.target.nodeType is 1

  # Action handler
  # @private
  _select: (e)->
    return if @disabled
    return unless e.target.matchesSelector(UI.Option.SELECTOR())
    @select e.target
    @dropdown.close()

  # Initializez to component
  # @private
  initialize: ->
    @dropdown = @querySelector(UI.Dropdown.SELECTOR())
    @label = @querySelector(UI.Label.SELECTOR())
    @name = @getAttribute('name')

    @addEventListener 'DOMNodeRemoved', @_nodeRemoved
    @addEventListener 'DOMNodeInserted', @_nodeAdded
    @addEventListener UI.Events.action, @_select

    @selectDefault()

  # Select option by default algorithm:
  #
  # * Selected option
  # * First option
  selectDefault: ->
    selected = @querySelector(UI.Option.SELECTOR()+"[selected]:not([disposed])")
    selected ?= @querySelectorAll(UI.Option.SELECTOR()+":not([disposed])")[0]
    @select selected

  # Select option
  # @param [UI.Option / String] The option element or value to be selected
  select: (value)->

    if value instanceof HTMLElement
      # TODO - Child node check
      selected = value
    else
      selected = @querySelector(UI.Option.SELECTOR()+"[value='#{value}']") or null

    unless selected
      @label?.textContent = ""
      @selectedOption.selected = false if @selectedOption
      @fireEvent 'change'
      return

    return if @selectedOption is selected

    @selectedOption?.selected = false
    selected.selected = true
    @label?.textContent = @selectedOption.textContent
    @fireEvent 'change'
