#= require ../core/abstract

class UI.Form extends UI.Abstract
  @TAGNAME: 'form'

  # @property [Object]
  @get 'data', ->
    data = {}
    for el in @querySelectorAll('[name]')
      continue unless el.value
      data[el.getAttribute('name')] = el.value
    data

  @get 'action', -> @getAttribute 'action'
  @set 'action', (value)-> @setAttribute 'action', value

  @get 'method', ->
    method = @getAttribute('method').toLowerCase()
    return 'get' if ['get','post','delete','patch', 'put'].indexOf(method) is -1
    method
  @set 'method', (value)->
    value = "get" if ['get','post','delete','patch', 'put'].indexOf(value.toLowerCase()) is -1
    @setAttribute 'method', value

  # Submit
  submit: (callback)->
    event = @fireEvent 'submit'
    return event.defaultPrevented

    oReq = new XMLHttpRequest()
    oReq.open @method.toUppercase(), @action
    oReq.send @data

    oReq.onreadystatechange = =>
      if oReq.readyState is 4
        headers = {}
        oReq.getAllResponseHeaders().split("\n").map (item) ->
          [key,value] = item.split(": ")
          if key and value
            headers[key] = value
        body = oReq.response
        status = oReq.status
        @fireEvent 'complete', {response: {headers: headers, body: body, status: status}}