color = class Color
  constructor: (color = "FFFFFF") ->
    color = color.toString()
    color = color.replace /\s/g, ''
    if (match = color.match /^#?([0-9a-f]{3}|[0-9a-f]{6})$/i)
      if color.match /^#/
        hex = color[1..]
      else
        hex = color
      if hex.length is 3
        hex = hex.replace(/([0-9a-f])/gi, '$1$1')
      @type = 'hex'
      @_hex = hex
      @_alpha = 100
      @_update 'hex'
    else if (match = color.match /^hsla?\((-?\d+),\s*(-?\d{1,3})%,\s*(-?\d{1,3})%(,\s*([01]?\.?\d*))?\)$/)?
      @type = 'hsl'
      @_hue = parseInt(match[1]).clampRange 0, 360
      @_saturation = parseInt(match[2]).clamp 0, 100
      @_lightness = parseInt(match[3]).clamp 0, 100
      @_alpha = parseInt(parseFloat(match[5])*100) || 100
      @_alpha = @_alpha.clamp 0, 100
      @type += if match[5] then "a" else ""
      @_update 'hsl'
    else if (match = color.match /^rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})(,\s*([01]?\.?\d*))?\)$/)?
      @type = 'rgb'
      @_red = parseInt(match[1]).clamp 0, 255
      @_green = parseInt(match[2]).clamp 0, 255
      @_blue = parseInt(match[3]).clamp 0, 255
      @_alpha = parseInt(parseFloat(match[5])*100) || 100
      @_alpha = @_alpha.clamp 0, 100
      @type += if match[5] then "a" else ""
      @_update 'rgb'
    else
      throw 'Wrong color format!'

  invert: ->
    @_red = 255 - @_red
    @_green = 255 - @_green
    @_blue = 255 - @_blue
    @_update 'rgb'
    @

  mix: (color2, alpha = 50) ->
    color2 = new Color(color2) unless color2 instanceof Color
    c = new Color()
    for item in ['red','green','blue']
      c[item] = Math.round((color2[item] / 100 * (100 - alpha))+(@[item] / 100 * alpha)).clamp 0, 255
    c

  _hsl2rgb: ->
    h = @_hue / 360
    s = @_saturation / 100
    l = @_lightness / 100
    if s is 0
      val = Math.round(l * 255)
      @_red = val
      @_green = val
      @_blue =val
    if l < 0.5
      t2 = l * (1 + s)
    else
      t2 = l + s - l * s
    t1 = 2 * l - t2
    rgb = [ 0, 0, 0 ]
    i = 0

    while i < 3
      t3 = h + 1 / 3 * -(i - 1)
      t3 < 0 and t3++
      t3 > 1 and t3--
      if 6 * t3 < 1
        val = t1 + (t2 - t1) * 6 * t3
      else if 2 * t3 < 1
        val = t2
      else if 3 * t3 < 2
        val = t1 + (t2 - t1) * (2 / 3 - t3) * 6
      else
        val = t1
      rgb[i] = val * 255
      i++
    @_red = Math.round(rgb[0])
    @_green = Math.round(rgb[1])
    @_blue = Math.round(rgb[2])

  _hex2rgb: ->
    value = parseInt(@_hex, 16)
    @_red = value >> 16
    @_green = (value >> 8) & 0xFF
    @_blue = value & 0xFF

  _rgb2hex: ->
    value = (@_red << 16 | (@_green << 8) & 0xffff | @_blue)
    x = value.toString(16)
    x = '000000'.substr(0, 6 - x.length) + x
    @_hex = x.toUpperCase()

  _rgb2hsl: ->
    r = @_red / 255
    g = @_green / 255
    b = @_blue / 255
    min = Math.min(r, g, b)
    max = Math.max(r, g, b)
    delta = max - min
    if max is min
      h = 0
    else if r is max
      h = (g - b) / delta
    else if g is max
      h = 2 + (b - r) / delta
    else h = 4 + (r - g) / delta  if b is max
    h = Math.min(h * 60, 360)
    h += 360  if h < 0
    l = (min + max) / 2
    if max is min
      s = 0
    else if l <= 0.5
      s = delta / (max + min)
    else
      s = delta / (2 - max - min)
    @_hue = h
    @_saturation = s * 100
    @_lightness = l *100

  _update: (type) ->
    switch type
      when 'rgb'
        @_rgb2hsl()
        @_rgb2hex()
      when 'hsl'
        @_hsl2rgb()
        @_rgb2hex()
      when 'hex'
        @_hex2rgb()
        @_rgb2hsl()

  toString: (type = 'hex')->
    switch type
      when "rgb"
        "rgb(#{@_red}, #{@_green}, #{@_blue})"
      when "rgba"
        "rgba(#{@_red}, #{@_green}, #{@_blue}, #{@alpha/100})"
      when "hsl"
        "hsl(#{@_hue}, #{Math.round(@_saturation)}%, #{Math.round(@_lightness)}%)"
      when "hsla"
        "hsla(#{@_hue}, #{Math.round(@_saturation)}%, #{Math.round(@_lightness)}%, #{@alpha/100})"
      when "hex"
        @hex

['red','green','blue'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @["_"+item]
    set: (value) ->
      @["_"+item] = parseInt(value).clamp 0, 255
      @_update 'rgb'

['lightness','saturation'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @["_"+item]
    set: (value) ->
      @["_"+item] = parseInt(value).clamp 0, 100
      @_update 'hsl'

['rgba','rgb','hsla','hsl'].forEach (item) ->
  Object.defineProperty Color::, item,
    get: ->
      @toString(item)

Object.defineProperties Color::,
  hex:
    get: ->
      "#"+@_hex
    set: (value) ->
      @_hex = value
      @_update 'hex'
  hue:
    get: ->
      @_hue
    set: (value) ->
      @_hue = parseInt(value).clampRange 0, 360
      @_update 'hsl'
  alpha:
    get: ->
      @_alpha
    set: (value) ->
      @_alpha = parseInt(value).clamp 0, 100

class ColorPicker
  constructor: ->
    @el = document.createElement 'picker'
    document.body.appendChild @el

    document.addEventListener UI.Events.action, (e)=>
      picker = getParent(e.target,'picker')
      unless picker
        @hide()
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

    @el.addEventListener 'mousedown', (e)=>
      e.stopPropagation()
      @dragTriangle(e)
      @dragCircle(e)
      @el.addEventListener 'mousemove', @drag
      document.addEventListener 'mouseup', @end

  fromColor: (color)->
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
      @setBoundValue()

  dragTriangle: (e)=>
    rect = @triangle.getBoundingClientRect(@triangle)
    rect =
      top: rect.top + window.scrollY
      left: rect.left
      height: rect.height
    p1 = new Point(e.pageX, e.pageY)
    p = p1.diff new Point(rect.left, rect.top)
    if 0 < p.x < 82 and 0 < p.y < 82
      @point.style.top = p.y-6+"px"
      @point.style.left = p.x-6+"px"
      @endColor.lightness = Math.min((100-Math.round((p.y/82)*100)), (100-(Math.round((p.x/82)*50))))
      @endColor.saturation = Math.round((p.x/82)*100)
      @setBoundValue()

  setBoundValue: ->
    @bound?.value = @endColor.hex

  bind: (input) ->
    @bound = input

  drag: (e) =>
    @dragTriangle(e)
    @dragCircle(e)

  end: =>
    @el.removeEventListener 'mousemove', @drag
    document.removeEventListener 'mouseup', @end

  dragCircle: (e) =>
    rect = @circleCanvas.getBoundingClientRect()
    p = new Point(e.pageX, e.pageY)
    p1 = p.diff new Point(rect.left, rect.top+window.scrollY)
    top = p1.y-80
    left = p1.x-80
    r = Math.sqrt(Math.pow(top,2)+Math.pow(left,2))
    radius = 69
    if 60 < r < 80
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


class UI.Color extends UI.Abstract
  @TAGNAME: 'color'
  initialize: ->
    @addEventListener UI.Events.action, (e)->
      e.stopPropagation()
      ColorPicker.show @
    Object.defineProperty @, 'value',
      get: ->
        new color(getComputedStyle(@).backgroundColor).hex
      set: (value)->
        last = @value
        @textContent = value
        @style.backgroundColor = value
        if new color(value).lightness < 50
          @style.color = "#fff"
        else
          @style.color = "#000"
        if @value isnt last
          @fireEvent 'change'