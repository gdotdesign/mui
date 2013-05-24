#= require ../../core/abstract

class UI.Form extends UI.Abstract
  @TAGNAME: 'form'
  submit: ->
    event = @fireEvent('submit')
    unless event.defaultPrevented
      formData = new FormData()
      data = {}
      for el in @querySelectorAll('[name]')
        if el.value
          formData.append(el.getAttribute('name'), el.value)
          data[el.getAttribute('name')] = el.value
      UI.log('Sending request to: *'+@getAttribute('method').toUpperCase()+"* - _"+@getAttribute('action')+"_", data)
      oReq = new XMLHttpRequest()
      oReq.open("POST", "submitform.php")
      oReq.send(new FormData(formData))
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