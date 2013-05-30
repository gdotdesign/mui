#= require ui-range

class UI.Slider extends UI.Range
  @TAGNAME: 'slider'

  _setValue: (percent)->
    super
    @style.backgroundSize = "#{percent*100}% 100%"
