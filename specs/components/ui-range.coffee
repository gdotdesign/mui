Test.add 'Range', ->
  component = document.querySelector(UI.Range.SELECTOR())

  @case 'Range should return the range', ->
    @assert component.range is 200

  @case 'Min should return min attribute', ->
    @assert component.min.toString() is component.getAttribute('min')

  @case 'Min should set attribute min', ->
    component.min = 0
    @assert component.getAttribute('min') is "0"

  @case 'Min should not set knob position', ->
    @assert component._percent is 0.5
    component.min = -100
    @assert component._percent is 0.5

  @case 'Min should set value', ->
    @assert component.value is 0
    component.min = 0
    @assert component.value is 50
    component.min = -100

  @case 'Max should return max attribute', ->
    @assert component.max.toString() is component.getAttribute('max')

  @case 'Max should set attribute max', ->
    component.max = 0
    @assert component.getAttribute('max') is "0"

  @case 'Max should not set knob position', ->
    @assert component._percent is 0.5
    component.max = 100
    @assert component._percent is 0.5

  @case 'Max should set value', ->
    @assert component.value is 0
    component.max = 0
    @assert component.value is -50
    component.max = 100

  @case 'Value should return value', ->
    @assert component.value is 0

  @case 'Value should set the knobs position', ->
    @assert component.knob.style.left is "50%"
    component.value = 100
    @assert component.knob.style.left is "100%"

  @case 'Setting value lower then minimum should set it to minimum', ->
    component.value = -300
    @assert component.value is -100
  @case 'Setting value bigger then maximum should set it to maximum', ->
    component.value = 300
    @assert component.value is 100

  @case 'Left / Down button should decrement value', ->
    component.fireEvent 'keydown', {keyCode: 37}
    @assert component.value is 98
    component.fireEvent 'keydown', {keyCode: 38}
    @assert component.value is 96

  @case 'Right / Up button should increment value', ->
    component.fireEvent 'keydown', {keyCode: 39}
    @assert component.value is 98
    component.fireEvent 'keydown', {keyCode: 40}
    @assert component.value is 100

  @case 'Left / Down button should decrement value (shift)', ->
    component.fireEvent 'keydown', {keyCode: 37, shiftKey: true}
    @assert component.value is 80
    component.fireEvent 'keydown', {keyCode: 38, shiftKey: true}
    @assert component.value is 60

  @case 'Right / Up button should increment value  (shift)', ->
    component.fireEvent 'keydown', {keyCode: 39, shiftKey: true}
    @assert component.value is 80
    component.fireEvent 'keydown', {keyCode: 40, shiftKey: true}
    @assert component.value is 100