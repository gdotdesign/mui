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
    @assert modal.isOpen
    modal.toggle()
    @assert !modal.isOpen

  @case "Toggle should not toggle the open attibute if the element is disabled", ->
    modal.disabled = true
    @assert !modal.isOpen
    modal.toggle()
    @assert !modal.isOpen
    modal.disabled = false

  @case "Close should not remove the open attibute if the element is disabled", ->
    modal.open()
    @assert modal.hasAttribute('open')
    modal.disabled = true
    modal.close()
    @assert modal.hasAttribute('open')
    modal.disabled = false
    modal.close()

  @case "Open should not add the open attribute if the element is disabled", ->
    @assert !modal.hasAttribute('open')
    modal.disabled = true
    modal.open()
    @assert !modal.hasAttribute('open')

