Test.add 'iInput',->
  component = document.querySelector(UI.Text.SELECTOR())

  @case "Value should get/set textContent", ->
    component.textContent = "WTF"
    @assert component.value if component.textContent
    component.value = ""
    @assert component.textContent is ""

  @case "Disabled should also toggle contenteditable", ->
    component.disabled = true
    @assert !component.hasAttribute('contenteditable')
    component.disabled = false
    @assert component.hasAttribute('contenteditable')

  @case "Cleanup should remove only br tag", ->
    component.appendChild document.createElement 'br'
    @assert component.children.length is 1
    component.cleanup()
    @assert component.children.length is 0

  @case "Cleanup should normalize tag", ->
    component.textContent = "\t\n"
    @assert component.textContent.length is 2
    component.cleanup()
    @assert component.textContent.length is 0

  @case "Should cleanup on blur", ->
    component.appendChild document.createElement 'br'
    @assert component.children.length is 1
    component.fireEvent('blur')
    @assert component.children.length is 0

  @case "Should set contenteditable on initialize", ->
    el = UI.Text.create()
    @assert component.hasAttribute('contenteditable')