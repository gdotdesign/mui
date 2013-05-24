#= require ../core/abstract

class UI.Form extends UI.Abstract
  @TAGNAME: 'form'

  geather: ->
    data = {}
    for el in @querySelectorAll('[name]')
      continue unless el.value
      data[el.getAttribute('name')] = el.value
    data

  submit: ->
    event = @fireEvent('submit')
    return event.defaultPrevented

    oReq = new XMLHttpRequest()
    oReq.open "POST", "submitform.php"
    oReq.send @geather()

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