Test.add 'Button',->
  button = document.querySelector(UI.Button.SELECTOR())
  button2 = UI.Button.create()
  button3 = document.createElement('ui-button')

  @case "An existsing button should be processed on load", ->
    @assert button._processed

  @case "New button created with create() should be processed", ->
    @assert button2._processed

  @case "New button created with createElement() should not be processed", ->
    @assert !button3._processed

  @case "Inserting the button should process it", ->
    document.body.appendChild button3
    @assert button3._processed

  @case "An instance of button should get all methods from class", ->
    for key, fn of UI.Button::
      if key isnt 'initialize'
        @assert !!button[key]

  @case "Label should set textContent of the button", ->
    button.label = 'Test Button'
    @assert button.textContent is 'Test Button'

  @case "Label should return textContent of the button", ->
    @assert button.textContent is button.label

  @case "Type should return 'default' for no type", ->
    @assert button.type is 'default'

  @case "Type should set the type attribute of the button", ->
    button.type = 'info'
    @assert button.getAttribute('type') is 'info'

  @case "Type should return the type attribute  of the button", ->
    @assert button.type is button.getAttribute('type')

