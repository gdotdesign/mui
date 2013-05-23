Test.add 'Button',->
  button = document.querySelector(UI.Button.SELECTOR())

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
    button.type = null
  @case "Type should return the type attribute  of the button", ->
    @assert button.type is button.getAttribute('type')

  @case "It should not trigger click event if it is disabled", ->
    x = true
    button.disabled = true
    button.addEventListener 'click', (e)=>
      x = false
    button.click()
    @assert x
    button.disabled = false
