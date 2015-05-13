morphs = window.angular.module 'morphs'

morphs.controller 'SignInController', class SignInController
  constructor: ->
    console.log 'instantiating sign in controller'