morphs = window.angular.module 'morphs'


morphs.controller 'NavController', class NavController
  constructor: (@$scope, @$state, @UserService)->
    @$scope.ctrl = @

  get_user: ->
    return @UserService.user

  is_signed_in: ->
    return @UserService.is_signed_in()

  sign_out: ->
    @UserService.sign_out()
    @$state.go 'sign-in'
