qs = (args...)-> document.querySelector.apply document, args

NS = 'ui'
UI = {}
class UI.Abstract
	@wrap: (el)->
		for own key, fn of @::
			if key isnt 'initialize'
				el[key] = fn.bind(el)
		@::initialize?.call el

class UI.Select extends UI.Abstract
	@TAGNAME: 'select'
	@SELECTOR: NS+"\\:"+@TAGNAME

	initialize: ->
		@addEventListener 'click', (e)=>
			if e.target.webkitMatchesSelector(UI.Option.SELECTOR)
				@select(e.target.getAttribute('value'))
				@querySelector(UI.Dropdown.SELECTOR).style.display = 'none'
			else
				@querySelector(UI.Dropdown.SELECTOR).style.display = 'block'
		@selectDefault()

	selectDefault: ->
		selected = @querySelector(UI.Option.SELECTOR+"[selected]")
		selected ?= @querySelector(UI.Option.SELECTOR+":first-child")
		if selected
			@select(selected.getAttribute('value'))

	select: (value)->
		option = @querySelector(UI.Option.SELECTOR+"[value='#{value}']")
		@selectedOption = option or null
		@_setValue()

	_setValue: ->
		if @selectedOption
			@value = @selectedOption.getAttribute('value')
			@querySelector('span').textContent = @selectedOption.textContent

class UI.Option extends UI.Abstract
	@TAGNAME: 'option'
	@SELECTOR: NS+"\\:"+@TAGNAME

class UI.Label extends UI.Abstract
	@TAGNAME: 'label'
	@SELECTOR: NS+"\\:"+@TAGNAME
	initialize: ->
		@addEventListener 'click', =>
			name = @getAttribute('for')
			el = document.querySelector("[name=#{name}]")
			el?.focus()
			el?.click()

class UI.Checkbox extends UI.Abstract
	@TAGNAME: 'checkbox'
	@SELECTOR: NS+"\\:"+@TAGNAME

	initialize: ->
		@addEventListener 'click', =>
			if @getAttribute('checked') isnt null
				@removeAttribute('checked')
			else
				@setAttribute('checked',true)

class UI.Dropdown extends UI.Abstract
	@TAGNAME: 'dropdown'
	@SELECTOR: NS+"\\:"+@TAGNAME

	initialize: ->
		document.addEventListener 'click', (e)=>
			if e.target isnt @
				@style.display = 'none'
		, true

for tag, cls of UI
	if cls::initialize
		for el in document.querySelectorAll(cls.SELECTOR)
			cls.wrap el