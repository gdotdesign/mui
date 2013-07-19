Test.add 'Email', ->
  email = document.querySelector('ui-email')

  validTestCases = [
    'email@subdomain.domain.com'
    'firstname+lastname@domain.com'
    'email@123.123.123.123'
    '"email"@domain.com'
    '1234567890@domain.com'
    'email@domain-one.com'
    '_______@domain.com'
    'email@domain.name'
    'email@domain.co.jp'
    'firstname-lastname@domain.com'
  ]

  invalidTestCases = [
    'plainaddress'
    '#@%^%#$@#$@#.com'
    '@domain.com'
    'Joe Smith <email@domain.com>'
    'email.domain.com'
    'email@domain@domain.com'
    '.email@domain.com'
    'email.@domain.com'
    'email..email@domain.com'
    'あいうえお@domain.com'
    'email@domain.com  (Joe Smith)'
    'email@domain'
    'email@-domain.com'
    'email@domain..com'
    'email@[123.123.123.123]'
  ]

  @case "Component should be valid for the following test cases", ->
    for test in validTestCases
      email.value = ''
      @assert !email.valid
      @assert email.invalid
      email.value = test
      @assert email.valid
      @assert !email.invalid

  @case "Component should be invalid for the following test cases", ->
    for test in invalidTestCases
      email.value = 'test@test.com'
      console.log test
      @assert email.valid
      @assert !email.invalid
      email.value = test
      @assert !email.valid
      @assert email.invalid

    email.value = ''
    email.removeAttribute('required')
    email.validate()