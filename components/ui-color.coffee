#= require ui-text
#= require ../core/color

# TODO: Move it to own file somewhere
picker = class
  constructor: ->
    @el = document.createElement 'picker'
    document.body.appendChild @el

    document.addEventListener UI.Events.action, (e)=>
      picker = getParent(e.target,'picker')
      if picker
        e.preventDefault()
    @circleCanvas = document.createElement 'canvas'
    @triangle = document.createElement 'triangle'
    @triangle.appendChild document.createElement 'gradient'
    @triangle.style.background = 'red'
    @circleCanvas.width = 160
    @circleCanvas.height = 160
    @drawHSLACone(160)

    for point in ['point','point2']
      @[point] = document.createElement 'point'

    @color = new Color("#ff0000")
    @endColor = new Color("#ff0000")
    @triangle.style.width = 82+"px"
    @triangle.style.height = 82+"px"
    @el.appendChild @triangle
    @el.appendChild @circleCanvas
    @triangle.appendChild @point
    @el.appendChild @point2

    @drag = new Drag @el
    @el.addEventListener 'dragmove', (e)=>
      e.stopPropagation()
      @dragCircle(e)
      @dragTriangle(e)

    @el.addEventListener 'dragstart', (e)=>
      e.stopPropagation()
      @dragCircle(e)
      @dragTriangle(e)

  fromColor: (color,set=true)->
    try
      c = new Color(color)
      radius = 69
      @angleRad = -c.hue*(Math.PI/180)
      @point2.style.top = radius*Math.sin(@angleRad)+85+"px"
      @point2.style.left = radius*Math.cos(@angleRad)+85+"px"
      @point.style.left = (c.saturation/100)*82-6+"px"
      @point.style.top = (Math.min((100-c.lightness)/100,(100-c.saturation/50))*82)-6+"px"
      @color.hue = c.hue
      @endColor = c
      @triangle.style.background = @color.hex
      @setBoundValue() if set

  dragTriangle: (e)=>
    return if e._stop
    rect = @triangle.getBoundingClientRect(@triangle)
    p1 = new Point(@drag.position.x, @drag.position.y)
    p = p1.diff new Point(rect.left, rect.top + window.scrollY)
    @point.style.top = (p.y-6).clamp(-6,76)+"px"
    @point.style.left = (p.x-6).clamp(-6,76)+"px"
    @endColor.lightness = Math.min((100-Math.round((p.y/82)*100)), (100-(Math.round((p.x/82)*50))))
    @endColor.saturation = Math.round((p.x/82)*100)
    @setBoundValue()

  setBoundValue: ->
    @bound?.value = @endColor.hex

  bind: (input) ->
    @bound = input

  dragCircle: (e) =>
    rect = @circleCanvas.getBoundingClientRect()
    p = new Point(@drag.position.x, @drag.position.y)
    p1 = p.diff new Point(rect.left, rect.top+window.scrollY)
    top = p1.y-80
    left = p1.x-80
    r = Math.sqrt(Math.pow(top,2)+Math.pow(left,2))
    radius = 69
    if 60 < r < 80
      e._stop = true
      @angleRad = Math.atan2(top,left)
      @angle = @angleRad*(180/Math.PI)
      @point2.style.top = radius*Math.sin(@angleRad)+85+"px"
      @point2.style.left = radius*Math.cos(@angleRad)+85+"px"
      @endColor.hue = @color.hue = 360-@angle
      @triangle.style.background = @color.hex
      @setBoundValue()

  drawHSLACone: (width) ->
    ctx = @circleCanvas.getContext '2d'
    ctx.translate width/2, width/2
    w2 = -width/2
    ang = width / 50
    angle = (1/ang)*Math.PI/180
    i = 0
    for i in [0..(360)*(ang)-1]
      c = new Color("#ff0000")
      c.hue = 360-(i/ang)
      ctx.strokeStyle = c.hex
      ctx.beginPath()
      ctx.moveTo(width/2-20,0)
      ctx.lineTo(width/2,0)
      ctx.stroke()
      ctx.rotate(angle)

  hide: ->
    if getComputedStyle(@el).display is 'block'
      @el.style.display = 'none'

  show: (el) ->
    @bind el
    @startColor = el.value
    rect = el.getBoundingClientRect()
    rect =
      top: rect.top + window.scrollY
      left: rect.left
      height: rect.height
      width: rect.width
    @fromColor el.value
    if window.innerWidth < 180+rect.left
      @el.classList.remove 'left'
      @el.classList.add 'right'
      @el.style.left = rect.left-180+rect.width+"px"
    else
      @el.style.left = rect.left+"px"
      @el.classList.remove 'right'
      @el.classList.add 'left'
    if window.innerHeight < 180+rect.top
      @el.style.top = rect.top-rect.height-163+"px"
      @el.classList.remove 'bottom'
      @el.classList.add 'top'
    else
      @el.style.top = rect.top+rect.height+"px"
      @el.classList.remove 'top'
      @el.classList.add 'bottom'
    @el.style.display = 'block'

color = Color
# Color component
class UI.Color extends UI.Text
  # The tagname of the component
  @TAGNAME: 'color'

  # @property [String] The hex reperesentation of the color
  @get 'value', -> new color(getComputedStyle(@).backgroundColor).hex
  @set 'value', (value)->
    last = @value
    unless document.querySelector(':focus') isnt @
      ColorPicker.fromColor value, false
    try
      c = new color(value)
      @style.backgroundColor = c.hex
      @style.color =  if c.lightness < 50 then "#fff" else "#000"
      @fireEvent 'change' if @value isnt last
      @textContent = value.replace("#",'')

  # Focus event handler
  # @param [Event] e
  # @private
  _focus: (e)->
    e.stopPropagation()
    return if @disabled
    ColorPicker.show @

  # Keypress event handler
  # @param [Event] e
  # @private
  _keypress: (e)->
    # FIX: Enable arrow keys in Firefox
    return if [39,37,8,46].indexOf(e.keyCode) isnt -1
    return e.preventDefault() unless /^[0-9A-Za-z]$/.test String.fromCharCode(e.charCode)
    @value = @textContent

  # Keyup event handler
  # @param [Event] e
  # @private
  _keyup: (e)-> @value = @textContent

  # Blur event handler
  # @private
  _blur: ->
    ColorPicker.hide()
    @value = @textContent

  # Initializes the component
  # @private
  initialize: ->
    window.ColorPicker ?= new picker
    @setAttribute 'contenteditable', true
    @setAttribute 'spellcheck', false

    @addEventListener 'focus', @_focus
    @addEventListener UI.Events.keypress, @_keypress
    @addEventListener UI.Events.keyup, @_keyup
    @addEventListener UI.Events.blur, @_blur

    @value = @getAttribute('value') or '#fff'
