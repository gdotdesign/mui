#= require ../core/abstract
#= require i-validable

# Select component
class UI.Select extends UI.Abstract
  # Mixin implementations
  implements: [UI.iValidable]

  # Validators
  validators: [UI.validators.required]

  # The tagname of the component
  @TAGNAME: 'select'
  # Whether the component can receive focus
  @TABABLE: true

  @get 'dropdown', -> @querySelector(UI.Dropdown.SELECTOR())
  @get 'label', -> @querySelector(UI.Label.SELECTOR())

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
    e.stopImmediatePropagation()
    e.stopPropagation()
    @select e.target
    @blur()

  # Blur event handler
  # @private
  _blur: ->
    return if @disabled
    @dropdown?.close()

  # Focus event handler
  # @private
  _focus: ->
    return if @disabled
    @dropdown?.open()

  # Keydown event handler
  # @param [Event] e
  # @private
  _keydown: (e)->
    return if [37,38,39,40].indexOf(e.keyCode) is -1
    parent = @selectedOption.parentNode
    index = @selectedOption.index()
    switch e.keyCode
      when 37, 38 # LEFT
        e.preventDefault()
        @select parent.children[(--index).clamp(0,parent.children.length-1)]
      when 39, 40 # RIGHT
        e.preventDefault()
        @select parent.children[(++index).clamp(0,parent.children.length-1)]

  # Initializes to component
  # @private
  initialize: ->
    @name = @getAttribute('name')

    @addEventListener 'DOMNodeRemoved', @_nodeRemoved
    @addEventListener 'DOMNodeInserted', @_nodeAdded
    @addEventListener UI.Events.action, @_select
    @addEventListener 'blur', @_blur
    @addEventListener 'focus', @_focus
    @addEventListener 'keydown', @_keydown

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
