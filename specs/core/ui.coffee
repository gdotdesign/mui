UI.onBeforeLoad = ->
UI.onLoad = ->

Test.spyOn UI, '_insert'
Test.spyOn UI, 'load'
Test.spyOn UI, '_wrapPassword'
Test.spyOn UI, 'onBeforeLoad'
Test.spyOn UI, 'onLoad'

Test.add 'UI', ->
  @case '_wrapPassword should run 1 time', ->
    @assert UI._wrapPassword.calls is 1

  @case 'load should run as may times as many ui-* elements', ->
    @assert UI.load.calls is window.startElementCount+1

  @case 'onBeforeLoad should run only once', ->
    @assert UI.onBeforeLoad.calls is 1

  @case 'onLoad should run only once', ->
    @assert UI.onLoad.calls is 1
