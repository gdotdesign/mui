#= require ui-range

# Slider component
class UI.Slider extends UI.Range
  # The tagname of the component
  @TAGNAME: 'slider'

  # Sets the value by percentage
  # @param [Number] Percent
  # @private
  _setValue: (percent)->
    super
    @style.backgroundSize = "#{percent*100}% 100%"
