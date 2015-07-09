morphs = window.angular.module 'morphs', [
  'ui.router',
  'ui.bootstrap',
  'ipCookie',
  'uiGmapgoogle-maps',
  'restangular',
  'cgNotify',
  'users',
  'nav',
]

HEADER_NAME = 'Morphs-Handle-Errors-Generically';
specificallyHandleInProgress = false;
 
morphs.factory 'RequestsErrorHandler', ($q, $log, $injector) ->
  # The user's API for claiming responsibility for requests
  specificallyHandled: (specificallyHandledBlock) ->
    specificallyHandleInProgress = true
    try return specificallyHandledBlock() finally specificallyHandleInProgress = false
 
  # Response interceptor for handling errors generically
  responseError: (rejection) ->
    shouldHandle = rejection and rejection.config and rejection.config.headers and rejection.config.headers[HEADER_NAME]
    if (shouldHandle)
      notify = $injector.get 'notify'
      notify "Something went wrong with your request, please try again or contact support."

    return $q.reject(rejection);
 
morphs.config ($provide, $httpProvider) ->
    $httpProvider.interceptors.push 'RequestsErrorHandler'

    # Decorate $http to add a special header by default.
    addHeaderToConfig = (config) ->
        config = config or {}
        config.headers = config.headers or {}
 
        # Add the header unless user asked to handle errors himself
        if  !specificallyHandleInProgress
            config.headers[HEADER_NAME] = true
 
        return config

    # The rest here is mostly boilerplate needed to decorate $http safely
    $provide.decorator '$http', ($delegate) -> 
        decorateRegularCall = (method) ->
            return (url, config) ->
                return $delegate[method] url, addHeaderToConfig config
 
        decorateDataCall = (method) ->
            return (url, data, config) ->
                return $delegate[method](url, data, addHeaderToConfig(config));
 
        copyNotOverriddenAttributes = (newHttp) ->
            for attr in $delegate
                if  !newHttp.hasOwnProperty attr
                    if typeof($delegate[attr]) == 'function'
                        newHttp[attr] = () ->
                            return $delegate.apply $delegate, arguments
                    else
                        newHttp[attr] = $delegate[attr];
 
        newHttp = (config) ->
            return $delegate addHeaderToConfig config;
 
        newHttp.get = decorateRegularCall 'get'
        newHttp.delete = decorateRegularCall 'delete'
        newHttp.head = decorateRegularCall 'head'
        newHttp.jsonp = decorateRegularCall 'jsonp'
        newHttp.post = decorateDataCall 'post'
        newHttp.put = decorateDataCall 'put'
 
        copyNotOverriddenAttributes newHttp
 
        return newHttp;
 

morphs.config (uiGmapGoogleMapApiProvider) ->
  uiGmapGoogleMapApiProvider.configure {
    #key: 'your api key',
    v: '3.17',
    libraries: 'places,geometry'
  }


morphs.config (RestangularProvider, API_ENDPOINT) ->
  RestangularProvider.setBaseUrl API_ENDPOINT

  RestangularProvider.setResponseExtractor (response, operation) ->
    # This is a get for a list
    if operation == 'getList'
      # Return an Array with one special property with all of the metadata
      newResponse = response.results;
      newResponse.meta = {
        count: response.count,
        limit: response.limit,
        offset: response.offset
      };
      return newResponse;
    else
      # An element
      return response;

morphs.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/sign-in'

  $stateProvider.state 'instructions', {
    url: '/instructions'
    templateUrl: 'morphs/templates/instructions.html'
    is_private: true
  }

  $stateProvider.state 'surveys', {
    url: '/surveys'
    abstract: 'true'
    template: '<div ui-view></div'
    is_private: true
  }

  $stateProvider.state 'surveys.list', {
    url: '/list'
    templateUrl: 'morphs/templates/surveys.list.html'
    controller: 'ListSurveysController'
    is_private: true
  }

  $stateProvider.state 'surveys.create', {
    url: '/create'
    templateUrl: 'morphs/templates/surveys.create.html'
    controller: 'CreateSurveyController'
    is_private: true
  }

  $stateProvider.state 'surveys.details', {
    abstract: true
    url: '/:survey_id'
    templateUrl: 'morphs/templates/surveys.details.html'
    controller: 'UpdateSurveyController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.export-results', {
    controller: 'ExportResultsController'
    url: '/export-results'
    templateUrl: 'morphs/templates/surveys.details.export-results.html'
    is_private: true
  }

  $stateProvider.state 'surveys.details.search-results', {
    abstract: true
    url: '/search-results'
    template: '<div ui-view></div'
    is_private: true
  }

  $stateProvider.state 'surveys.details.search-results.list', {
    url: '/list'
    templateUrl: 'morphs/templates/surveys.details.search-results.list.html'
    controller: 'ListSearchResultsController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.search-results.details', {
    url: '/:search_result_id'
    templateUrl: 'morphs/templates/surveys.details.search-results.details.html'
    controller: 'UpdateSearchResultController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches', {
    abstract: true
    url: '/searches'
    template: '<div ui-view></div>'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches.list', {
    url: '/list'
    templateUrl: 'morphs/templates/surveys.details.searches.list.html'
    controller: 'ListSearchesController'
    is_private: true
  }

  $stateProvider.state 'surveys.details.searches.create', {
    url: '/create'
    templateUrl: 'morphs/templates/surveys.details.searches.create.html'
    controller: 'CreateSearchController'
    is_private: true
  }

morphs.run ($rootScope, $state, $stateParams) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams

morphs.run (notify) ->
  notify.config {
    duration: 5000,
  }

morphs.run ($rootScope, $state, $log, UserService, notify) ->
  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    $log.debug "Attempting to change state to '#{toState.name}'."
    if (toState.is_private and not UserService.is_signed_in())
      notify 'Please sign in.'
      $log.debug "State '#{toState.name} is private and user is not signed in, 
      going to 'sign-in' instead."
      # Prevent the existing state change so that we can start a new one.
      event.preventDefault()
      $state.go 'sign-in'
