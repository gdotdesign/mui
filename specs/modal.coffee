Test.add 'Modal',->
  modal = document.querySelector(UI.Modal.SELECTOR())

  @case "Modal should be inserted into the body on initialization", ->
    mod = UI.Modal.create()
    @assert mod.parentNode is document.body

  @case "Toggle should toggle the open attribute", ->
    @assert !modal.hasAttribute('open')
    modal.toggle()
    @assert modal.hasAttribute('open')
    modal.toggle()
    @assert !modal.hasAttribute('open')

  @case "Toggle should not work if modal is disabled", ->
    modal.disabled = true
    @assert !modal.hasAttribute('open')
    modal.toggle()
    @assert !modal.hasAttribute('open')
    modal.disabled = false

  @case "isOpen property should return accordingly", ->
    modal.toggle()
    @assert modal.isOpen is true
    modal.toggle()
    @assert modal.isOpen is false
