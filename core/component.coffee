class Component extends UI.Abstract
  initialize: ->
    for type,method of @events
      if type.match /\s/
        [type,selector] = type.split /\s/
        type = UI.Events[type] if UI.Events[type]
        @delegateEventListener type, selector, @[method].bind @
      else
        type = UI.Events[type] if UI.Events[type]
        @addEventListener type,@[method].bind @

    UI._build.call(@, @markup, @) if @markup
