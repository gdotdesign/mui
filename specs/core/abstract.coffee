Test.add 'Abstract',->
  selector = UI.Toggle.SELECTOR()
  el = document.querySelector(selector)
  el2 = UI.Toggle.create()
  el3 = document.createElement(selector)

  @case "An existsing Component should be processed on load", ->
    @assert el._processed
  @case "New Component created with create() should be processed", ->
    @assert el2._processed
  @case "New Component created with createElement() should not be processed", ->
    @assert !el3._processed
  @case "Inserting the Component should process it", ->
    document.body.appendChild el3
    @assert el3._processed

  @case "Disabled property should be aliased for disabled attribute", ->
    @assert !el.hasAttribute('disabled')
    el.disabled = true
    @assert el.hasAttribute('disabled')
    el.disabled = false
    @assert !el.hasAttribute('disabled')

  @case "An instance of Component should get all methods from class", ->
    for key of UI._geather(UI.Toggle::)
      if key isnt 'initialize' and key isnt 'constructor'
        @assert Object.getOwnPropertyDescriptor el3, key
    document.body.removeChild el3

  @case "Create should throw error for non object attribute", ->
    x = true
    try
      UI.Toggle.create('error')
      x = false
    catch e
    @assert x

  @case "Promise should retrun a function that creates a component", ->
    fn = UI.Toggle.promise()
    @assert fn instanceof Function
    el = fn()
    @assert el instanceof Element
    @assert el.tagName is 'UI-TOGGLE'
