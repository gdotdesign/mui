class UI.Message extends UI.Abstract
  @TAGNAME: 'message'
  @MARKUP: [{content: UI.promiseElement('div')}]

class UI.Notification extends UI.Abstract
  @TAGNAME: 'notification'
  defaultTimeout: 5000

  push: (content, type)->
    message = UI.Message.create({type: type})
    message.content.innerHTML = content
    @appendChild message

    remove = (=> @removeChild message).once()
    if window.animationSupport
      for type in ['animationend','webkitAnimationEnd','oanimationend','MSAnimationEnd']
        message.addEventListener type, remove
    else
      setTimeout remove, @defaultTimeout
