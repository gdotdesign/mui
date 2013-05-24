Test.add 'Abstract',->
  tag = 'Button'
  selector = UI[tag].SELECTOR()
  el = document.querySelector(selector)
  el2 = UI[tag].create()
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
    for key, fn of UI[tag]::
      if key isnt 'initialize'
        @assert !!el[key]
    document.body.removeChild el3