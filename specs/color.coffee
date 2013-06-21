Test.add "Color", ->
  TEST_DATA_COLOR = """
    hsl(0, 100%, 50%):rgb(255, 0, 0)
    hsl(60, 100%, 50%):rgb(255, 255, 0)
    hsl(120, 100%, 50%):rgb(0, 255, 0)
    hsl(180, 100%, 50%):rgb(0, 255, 255)
    hsl(240, 100%, 50%):rgb(0, 0, 255)
    hsl(300, 100%, 50%):rgb(255, 0, 255)
    hsl(-360, 100%, 50%):rgb(255, 0, 0)
    hsl(-300, 100%, 50%):rgb(255, 255, 0)
    hsl(-240, 100%, 50%):rgb(0, 255, 0)
    hsl(-180, 100%, 50%):rgb(0, 255, 255)
    hsl(-120, 100%, 50%):rgb(0, 0, 255)
    hsl(-60, 100%, 50%):rgb(255, 0, 255)
    hsl(360, 100%, 50%):rgb(255, 0, 0)
    hsl(420, 100%, 50%):rgb(255, 255, 0)
    hsl(480, 100%, 50%):rgb(0, 255, 0)
    hsl(540, 100%, 50%):rgb(0, 255, 255)
    hsl(600, 100%, 50%):rgb(0, 0, 255)
    hsl(660, 100%, 50%):rgb(255, 0, 255)
    hsl(6120, 100%, 50%):rgb(255, 0, 0)
    hsl(-9660, 100%, 50%):rgb(255, 255, 0)
    hsl(99840, 100%, 50%):rgb(0, 255, 0)
    hsl(-900, 100%, 50%):rgb(0, 255, 255)
    hsl(-104880, 100%, 50%):rgb(0, 0, 255)
    hsl(2820, 100%, 50%):rgb(255, 0, 255)
    hsl(0, 100%, 50%):rgb(255, 0, 0)
    hsl(12, 100%, 50%):rgb(255, 51, 0)
    hsl(24, 100%, 50%):rgb(255, 102, 0)
    hsl(36, 100%, 50%):rgb(255, 153, 0)
    hsl(48, 100%, 50%):rgb(255, 204, 0)
    hsl(60, 100%, 50%):rgb(255, 255, 0)
    hsl(72, 100%, 50%):rgb(204, 255, 0)
    hsl(84, 100%, 50%):rgb(153, 255, 0)
    hsl(96, 100%, 50%):rgb(102, 255, 0)
    hsl(108, 100%, 50%):rgb(51, 255, 0)
    hsl(120, 100%, 50%):rgb(0, 255, 0)
    hsl(120, 100%, 50%):rgb(0, 255, 0)
    hsl(132, 100%, 50%):rgb(0, 255, 51)
    hsl(144, 100%, 50%):rgb(0, 255, 102)
    hsl(156, 100%, 50%):rgb(0, 255, 153)
    hsl(168, 100%, 50%):rgb(0, 255, 204)
    hsl(180, 100%, 50%):rgb(0, 255, 255)
    hsl(192, 100%, 50%):rgb(0, 204, 255)
    hsl(204, 100%, 50%):rgb(0, 153, 255)
    hsl(216, 100%, 50%):rgb(0, 102, 255)
    hsl(228, 100%, 50%):rgb(0, 51, 255)
    hsl(240, 100%, 50%):rgb(0, 0, 255)
    hsl(240, 100%, 50%):rgb(0, 0, 255)
    hsl(252, 100%, 50%):rgb(51, 0, 255)
    hsl(264, 100%, 50%):rgb(102, 0, 255)
    hsl(276, 100%, 50%):rgb(153, 0, 255)
    hsl(288, 100%, 50%):rgb(204, 0, 255)
    hsl(300, 100%, 50%):rgb(255, 0, 255)
    hsl(312, 100%, 50%):rgb(255, 0, 204)
    hsl(324, 100%, 50%):rgb(255, 0, 153)
    hsl(336, 100%, 50%):rgb(255, 0, 102)
    hsl(348, 100%, 50%):rgb(255, 0, 51)
    hsl(360, 100%, 50%):rgb(255, 0, 0)
    hsl(0, 20%, 50%):rgb(153, 102, 102)
    hsl(0, 60%, 50%):rgb(204, 51, 51)
    hsl(0, 100%, 50%):rgb(255, 0, 0)
    hsl(60, 20%, 50%):rgb(153, 153, 102)
    hsl(60, 60%, 50%):rgb(204, 204, 51)
    hsl(60, 100%, 50%):rgb(255, 255, 0)
    hsl(120, 20%, 50%):rgb(102, 153, 102)
    hsl(120, 60%, 50%):rgb(51, 204, 51)
    hsl(120, 100%, 50%):rgb(0, 255, 0)
    hsl(180, 20%, 50%):rgb(102, 153, 153)
    hsl(180, 60%, 50%):rgb(51, 204, 204)
    hsl(180, 100%, 50%):rgb(0, 255, 255)
    hsl(240, 20%, 50%):rgb(102, 102, 153)
    hsl(240, 60%, 50%):rgb(51, 51, 204)
    hsl(240, 100%, 50%):rgb(0, 0, 255)
    hsl(300, 20%, 50%):rgb(153, 102, 153)
    hsl(300, 60%, 50%):rgb(204, 51, 204)
    hsl(300, 100%, 50%):rgb(255, 0, 255)
    hsl(0, 100%, 0%):rgb(0, 0, 0)
    hsl(0, 100%, 10%):rgb(51, 0, 0)
    hsl(0, 100%, 20%):rgb(102, 0, 0)
    hsl(0, 100%, 30%):rgb(153, 0, 0)
    hsl(0, 100%, 40%):rgb(204, 0, 0)
    hsl(0, 100%, 50%):rgb(255, 0, 0)
    hsl(0, 100%, 60%):rgb(255, 51, 51)
    hsl(0, 100%, 70%):rgb(255, 102, 102)
    hsl(0, 100%, 80%):rgb(255, 153, 153)
    hsl(0, 100%, 90%):rgb(255, 204, 204)
    hsl(0, 100%, 100%):rgb(255, 255, 255)
    hsl(60, 100%, 0%):rgb(0, 0, 0)
    hsl(60, 100%, 10%):rgb(51, 51, 0)
    hsl(60, 100%, 20%):rgb(102, 102, 0)
    hsl(60, 100%, 30%):rgb(153, 153, 0)
    hsl(60, 100%, 40%):rgb(204, 204, 0)
    hsl(60, 100%, 50%):rgb(255, 255, 0)
    hsl(60, 100%, 60%):rgb(255, 255, 51)
    hsl(60, 100%, 70%):rgb(255, 255, 102)
    hsl(60, 100%, 80%):rgb(255, 255, 153)
    hsl(60, 100%, 90%):rgb(255, 255, 204)
    hsl(60, 100%, 100%):rgb(255, 255, 255)
    hsl(120, 100%, 0%):rgb(0, 0, 0)
    hsl(120, 100%, 10%):rgb(0, 51, 0)
    hsl(120, 100%, 20%):rgb(0, 102, 0)
    hsl(120, 100%, 30%):rgb(0, 153, 0)
    hsl(120, 100%, 40%):rgb(0, 204, 0)
    hsl(120, 100%, 50%):rgb(0, 255, 0)
    hsl(120, 100%, 60%):rgb(51, 255, 51)
    hsl(120, 100%, 70%):rgb(102, 255, 102)
    hsl(120, 100%, 80%):rgb(153, 255, 153)
    hsl(120, 100%, 90%):rgb(204, 255, 204)
    hsl(120, 100%, 100%):rgb(255, 255, 255)
    hsl(180, 100%, 0%):rgb(0, 0, 0)
    hsl(180, 100%, 10%):rgb(0, 51, 51)
    hsl(180, 100%, 20%):rgb(0, 102, 102)
    hsl(180, 100%, 30%):rgb(0, 153, 153)
    hsl(180, 100%, 40%):rgb(0, 204, 204)
    hsl(180, 100%, 50%):rgb(0, 255, 255)
    hsl(180, 100%, 60%):rgb(51, 255, 255)
    hsl(180, 100%, 70%):rgb(102, 255, 255)
    hsl(180, 100%, 80%):rgb(153, 255, 255)
    hsl(180, 100%, 90%):rgb(204, 255, 255)
    hsl(180, 100%, 100%):rgb(255, 255, 255)
    hsl(240, 100%, 0%):rgb(0, 0, 0)
    hsl(240, 100%, 10%):rgb(0, 0, 51)
    hsl(240, 100%, 20%):rgb(0, 0, 102)
    hsl(240, 100%, 30%):rgb(0, 0, 153)
    hsl(240, 100%, 40%):rgb(0, 0, 204)
    hsl(240, 100%, 50%):rgb(0, 0, 255)
    hsl(240, 100%, 60%):rgb(51, 51, 255)
    hsl(240, 100%, 70%):rgb(102, 102, 255)
    hsl(240, 100%, 80%):rgb(153, 153, 255)
    hsl(240, 100%, 90%):rgb(204, 204, 255)
    hsl(240, 100%, 100%):rgb(255, 255, 255)
    hsl(300, 100%, 0%):rgb(0, 0, 0)
    hsl(300, 100%, 10%):rgb(51, 0, 51)
    hsl(300, 100%, 20%):rgb(102, 0, 102)
    hsl(300, 100%, 30%):rgb(153, 0, 153)
    hsl(300, 100%, 40%):rgb(204, 0, 204)
    hsl(300, 100%, 50%):rgb(255, 0, 255)
    hsl(300, 100%, 60%):rgb(255, 51, 255)
    hsl(300, 100%, 70%):rgb(255, 102, 255)
    hsl(300, 100%, 80%):rgb(255, 153, 255)
    hsl(300, 100%, 90%):rgb(255, 204, 255)
    hsl(300, 100%, 100%):rgb(255, 255, 255)
    """

  @case 'W3C Test Cases', ->
    for colors in TEST_DATA_COLOR.split("\n")
      [hsl,rgb] = colors.split ":"
      @assert new Color(hsl).hex is new Color(rgb).hex

  @case 'Constructor should create color from different formats', ->
    for format in ['#ff0','ff0','ffff00','#ffff00','rgba(255,255,0,0)','rgba(255    ,255,0    ,0)','rgb(255,255,0)','hsla(0,100%,0%,0)','rgba(255,255,0,0.5)']
      @assert !!new Color(format)

  @case 'Constructor default value should be FFFFFF', ->
    c = new Color
    @assert c.hex is "#FFFFFF"
    @assert c.red is 255
    @assert c.blue is 255
    @assert c.green is 255
    @assert c.hue is 0
    @assert c.saturation is 0
    @assert c.lightness is 100

  @case 'Hex should set color as hex', ->
    c = new Color
    c.hex = "000000"
    @assert c.hex is "#000000"
    @assert c.red is 0
    @assert c.blue is 0
    @assert c.green is 0
    @assert c.hue is 0
    @assert c.saturation is 0
    @assert c.lightness is 0

  @case "Hex should return hex presentation", ->
    c = new Color
    @assert c.hex is "#FFFFFF"

  @case 'Alpha should set value', ->
    c = new Color()
    c.alpha = 80
    @assert c.rgba is "rgba(255, 255, 255, 0.8)"
  @case 'Alpha should return alpha value', ->
    c = new Color()
    @assert c.alpha is 100
    c.alpha = 50
    @assert c.alpha is 50

  @case 'Red should set value', ->
    c = new Color()
    c.red = 80
    @assert c.rgb is "rgb(80, 255, 255)"
  @case 'Red should return red value', ->
    c = new Color()
    @assert c.red is 255
    c.red = 50
    @assert c.red is 50

  @case 'Green should set value', ->
    c = new Color()
    c.green = 80
    @assert c.rgb is "rgb(255, 80, 255)"
  @case 'Green should return green value', ->
    c = new Color()
    @assert c.green is 255
    c.green = 50
    @assert c.green is 50

  @case 'Blue should set value', ->
    c = new Color()
    c.blue = 80
    @assert c.rgb is "rgb(255, 255, 80)"
  @case 'Blue should return blue value', ->
    c = new Color()
    @assert c.blue is 255
    c.blue = 50
    @assert c.blue is 50

  @case 'Hue should set value', ->
    c = new Color("hsl(180,100%,50%)")
    c.hue = 360
    @assert c.hex is "#FF0000"
  @case 'Hue should return hue value', ->
    c = new Color()
    @assert c.hue is 0
    c.hue = 180
    @assert c.hue is 180

  @case 'Lightness should set lightness', ->
    c = new Color("#FF0000")
    @assert c.hex is "#FF0000"
    c.lightness = 100
    @assert c.hex is "#FFFFFF"
    c.lightness = 0
    @assert c.hex is "#000000"
  @case 'Lightness should set lightness is saturation is 0', ->
    c = new Color("#000000")
    c.lightness = 10
    @assert c.hex is "#1A1A1A"
  @case 'Lightness should return lightness value', ->
    c = new Color()
    @assert c.lightness is 100
    c.lightness = 80
    @assert c.lightness is 80

  @case 'Saturation should set saturation', ->
    c = new Color("#FF0000")
    @assert c.hex is "#FF0000"
    c.saturation = 80
    @assert c.hex is "#E61919"
  @case 'Saturation should return saturation value', ->
    c = new Color()
    @assert c.saturation is 0
    c.saturation = 80
    @assert c.saturation is 80

  @case 'Mix should mix colors', ->
    colors = [
      ['#f00','#00f',50,"7F007F"]
      ['#f00','#0ff',50,"7F7F7F"]
      ['#f70','#0aa',50,"7F9155"]
      ['#f00','#00f',100,"FF0000"]
      ['#f00','#00f',0,"0000FF"]

    ]
    for item in colors
      c = new Color(item[0])
      c1 = new Color(item[1])
      c2 = new Color(item[3])
      @assert c.mix(c1,item[2]).hex is c2.hex
  @case "Mix default percentage should be 50%", ->
    c = new Color()
    @assert c.mix(new Color("#000")).hex is '#7F7F7F'
  @case "Mix should mix string color", ->
    c = new Color()
    @assert c.mix("#000").hex is '#7F7F7F'

  @case 'Invert should invert colors', ->
    @assert new Color("#112233").invert().hex is "#EEDDCC"
    @assert new Color("rgba(245, 235, 225, 0.5)").invert().rgba is "rgba(10, 20, 30, 0.5)"

  for colors in ['rgb:rgb(255, 255, 255)','rgba:rgba(255, 255, 255, 1)','hsl:hsl(0, 0%, 100%)','hsla:hsla(0, 0%, 100%, 1)']
    [type,result] = colors.split ":"
    c = new Color()
    @case "#{type} should return #{type} representation", ->
      @assert c[type] is result
