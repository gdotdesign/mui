Test.add 'Button',->
  button = document.querySelector(UI.Button.SELECTOR())

  # Attributes
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