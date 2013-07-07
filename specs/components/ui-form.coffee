Test.add 'Form', ->
  form = document.querySelector('ui-form')
  email = form.querySelector('[name=email]')
  password = form.querySelector('[name=password]')

  @case "Data should not return elements with empty values", ->
    obj = form.data
    @assert obj.email is undefined
    @assert obj.password is undefined

  @case "Data should return elements with value", ->
    email.value = "test@user.com"
    password.value = "123456"
    obj = form.data
    @assert obj.email is "test@user.com"
    @assert obj.password is "123456"

  @case "Method should return get if not specified", ->
    @assert form.method is "get"

  @case "Method should return method attribute", ->
    form.setAttribute 'method', 'POST'
    @assert form.method is "post"

  @case "Method should set method attribute", ->
    form.method = "POST"
    @assert form.getAttribute('method') is 'post'

  @case "Action should set action attribute", ->
    form.action = "/form"
    @assert form.getAttribute('action') is  form.action

  @case "Action should return action attribute", ->
    @assert form.getAttribute('action') is  form.action

  @case "Submit should fire submit event", ->
    x = false
    fn = (e)->
      e.preventDefault()
      x = true
    form.addEventListener 'submit', fn
    form.submit()
    @assert x
    form.removeEventListener 'submit', fn

  @case "Submit should make XMLHTTPRequest and fire complete event", ->
    x = false
    fn = (e)->
      x = true
    form.addEventListener 'complete', fn
    form.submit()
    @assert x
