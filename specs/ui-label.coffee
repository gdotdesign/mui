Test.add 'Label',->
  component = document.querySelector(UI.Label.SELECTOR()+"[for]")

  @case "It should redirect to element named as the for attribute", ->
  	@assert document.querySelector(':focus') is null
  	target = document.querySelector("[name='#{component.getAttribute('for')}']")
  	target.addEventListener 'focus', =>
  		@assert true
  	component.click()