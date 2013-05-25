#= require ui-checkbox

class UI.Radio extends UI.Checkbox
	@TAGNAME: 'radio'
	toggle: ->
		super
		for radio in document.querySelectorAll(UI.Radio.SELECTOR()+"[name='#{@getAttribute('name')}']")
			continue if radio is @
			radio.checked = false