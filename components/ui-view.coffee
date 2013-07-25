# Backbone like view class
class UI.View extends UI.Abstract

  # Adds events from @events
  # @private
  _addEvents: ->
    for type,method of @events
      if type.match /\s/
        [type,selector] = type.split /\s/
        type = UI.Events[type] if UI.Events[type]
        @delegateEventListener type, selector, @[method].bind @
      else
        type = UI.Events[type] if UI.Events[type]
        @addEventListener type,@[method].bind @

  # Initializez the Component
  initialize: -> @_addEvents()
