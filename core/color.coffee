# Color type
class Color

  # @property [Number] Red compoment of the color
  @get 'red', -> @_red
  @set 'red', (value)->
    @_red = parseInt(value).clamp 0, 255
    @_update 'rgb'

  # @property [Number] Green compoment of the color
  @get 'green', -> @_green
  @set 'green', (value)->
    @_green = parseInt(value).clamp 0, 255
    @_update 'rgb'

  # @property [Number] Blue compoment of the color
  @get 'blue', -> @_blue
  @set 'blue', (value)->
    @_blue = parseInt(value).clamp 0, 255
    @_update 'rgb'

  # @property [Number] Lightness compoment of the color
  @get 'lightness', -> @_lightness
  @set 'lightness', (value)->
    @_lightness = parseInt(value).clamp 0, 100
    @_update 'hsl'

  # @property [Number] Saturation compoment of the color
  @get 'saturation', -> @_saturation
  @set 'saturation', (value)->
    @_saturation = parseInt(value).clamp 0, 100
    @_update 'hsl'

  # @property [String] RGB representation of the color
  @get 'rgb', -> @toString('rgb')
  # @property [String] RGBA representation of the color
  @get 'rgba', -> @toString('rgba')
  # @property [String] HSL representation of the color
  @get 'hsl', -> @toString('hsl')
  # @property [String] HSLA representation of the color
  @get 'hsla', -> @toString('hsla')

  # @property [String] HEX representation of the color
  @get 'hex', -> "#"+@_hex
  @set 'hex', (value) ->
    @_hex = value
    @_update 'hex'

  # @property [Number] Hue compoment of the color
  @get 'hue', -> @_hue
  @set 'hue', (value) ->
    @_hue = parseInt(value).clampRange 0, 360
    @_update 'hsl'

  # @property [Number] Alpha compoment of the color
  @get 'alpha', -> @_alpha
  @set 'alpha', (value) -> @_alpha = parseInt(value).clamp 0, 100

  # Creates a new Color instance
  # @param [String] color The string representation of the color
  # @throw [Error] When the color is incorrect
  constructor: (color = "FFFFFF") ->
    color = "rgba(0,0,0,0)" if color is 'transparent'
    color = color.trim().toString()
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

  # Inverts the color
  # @return [Color] Self
  invert: ->
    @_red = 255 - @_red
    @_green = 255 - @_green
    @_blue = 255 - @_blue
    @_update 'rgb'
    @

  # Mixes two colors together
  # @param [Color] color2 The other color
  # @param [Number] alpha The factor for mixing. 0 is will return the first color 100 will return the second.
  # @return [Color] The mixed color
  mix: (color2, alpha = 50) ->
    color2 = new Color(color2) unless color2 instanceof Color
    c = new Color()
    for item in ['red','green','blue']
      c[item] = Math.round((color2[item] / 100 * (100 - alpha))+(@[item] / 100 * alpha)).clamp 0, 255
    c

  # Converts Self hsl representation to rgb
  # @private
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

  # Converts Self hex representation to rgb
  # @private
  _hex2rgb: ->
    value = parseInt(@_hex, 16)
    @_red = value >> 16
    @_green = (value >> 8) & 0xFF
    @_blue = value & 0xFF

  # Converts Self rgb representation to hex
  # @private
  _rgb2hex: ->
    value = (@_red << 16 | (@_green << 8) & 0xffff | @_blue)
    x = value.toString(16)
    x = '000000'.substr(0, 6 - x.length) + x
    @_hex = x.toUpperCase()

  # Converts Self rgb representation to hsl
  # @private
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

  # Updates Self by type
  # @param [String] type - Either `rgb`, `hsl` or `hex`
  # @private
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

  # Returns the string representation of the color
  # @param [String] type - Either `rgb`, `rgba`, `hsl`, `hsla` or `hex`
  # @private
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

window.ColorType = Color