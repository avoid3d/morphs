morphs = window.angular.module 'morphs'

morphs.controller 'SignInController', class SignInController
  constructor: (@$scope, @$state, @UserService, @notify, @RequestsErrorHandler) ->
    @$scope.ctrl = @
    @sign_in_form = {
      email_address: null,
      password: null,
      error_messages: null,
    }

  sign_in: =>
    @RequestsErrorHandler.specificallyHandled =>
      @UserService.sign_in @sign_in_form.email_address, @sign_in_form.password
        .then (response) =>
          @$state.go 'surveys.list'
        , (error) =>
          if error.status == 403
            @notify 
              message: "That email address and password combination were not recognized."
              duration: 0
          else
            @notify 
              message: "Something went wrong signing you in. Please try again later or contact support."
              duration: 0


