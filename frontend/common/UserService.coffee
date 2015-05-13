morphs = window.angular.module 'morphs'

morphs.service 'UserService', class UserService
  constructor: ->
    console.log 'instantiating user service' 