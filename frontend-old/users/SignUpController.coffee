morphs = window.angular.module 'morphs'


morphs.controller 'SignUpController', class SignUpController
  constructor: (@$scope, @$state, @UserService, @notify) ->
    @$scope.ctrl = @
    @sign_up_form = {email_address: null, password: null, is_loading: false}

  sign_up: =>
    @sign_up_form.is_loading = true
    console.log @sign_up_form
    @UserService.sign_up @sign_up_form.email_address, @sign_up_form.password
      .then (response) =>
        @$state.go 'surveys.list'
      , (error) =>
        if error.status == 400
          console.log error
          @notify error.data.message
      .finally =>
        @sign_up_form.is_loading = false 
