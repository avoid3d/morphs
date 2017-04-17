morphs = window.angular.module 'morphs'

morphs.service 'UserService', class UserService
  constructor: (@Restangular, @ipCookie) ->
    @user = null
    @load_from_cookie()

  is_signed_in: () ->
    return !!@user

  persist_to_cookie: () ->
    @ipCookie 'session_and_user', {
      session: @session,
      user: @user,
    }

  load_from_cookie: () =>
    stored_session_and_user = @ipCookie 'session_and_user'
    if (stored_session_and_user)
      @session = stored_session_and_user.session
      @user = stored_session_and_user.user

  sign_in: (email_address, password) =>
    promise = @Restangular.all('sessions').post({email_address: email_address, password: password})

    promise.then (response) =>
      @session = response.session
      @user = response.user
      @persist_to_cookie()


    return promise

  sign_up: (email_address, password) =>
    console.log 'sign_up', email_address, password
    promise = @Restangular.all('users').post({email_address: email_address, password: password})

    promise.then (response) =>
      @user = response.user
      @session = response.session
      @persist_to_cookie()

    return promise

  sign_out: =>
    @user = null
    @session = null

    @ipCookie('session_and_user', null)
