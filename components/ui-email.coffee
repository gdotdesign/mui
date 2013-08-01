#= require ui-text

# Email component
#
# It's just like the text one, validation will be different.
class UI.Email extends UI.Text
  # Validators
  validators: UI.Text::validators.concat UI.validators.email

  # The tagname of the component
  @TAGNAME: 'email'