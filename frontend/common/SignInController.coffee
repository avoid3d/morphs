morphs = window.angular.module 'morphs'

morphs.controller 'SignInController', class SignInController
  constructor: (@$scope, @$state, @UserService) ->
    @$scope.ctrl = @
    @sign_in_form = {email_address: null, password: null}

  sign_in: =>
    @UserService.sign_in @sign_in_form.email_address, @sign_in_form.password
      .then (response) =>
        @$state.go 'surveys.list'


