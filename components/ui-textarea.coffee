#= require ../core/i-input

# Textarea Compontent
class UI.Textarea extends UI.iInput
  # Validators
  validators: UI.Text::validators
  
  # The tagname of the component
  @TAGNAME: 'textarea'