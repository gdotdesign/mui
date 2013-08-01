# Message for notification
class UI.Message extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'message'
  # Child Elements
  @MARKUP: [{content: UI.promiseElement('div')}]

# Notification Component
class UI.Notification extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'notification'

  # @property Default Timeout
  defaultTimeout: 5000

  # Push new notification
  # @param [String] Content
  # @param [String] Type
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
