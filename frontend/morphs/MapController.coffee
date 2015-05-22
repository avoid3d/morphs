morphs = window.angular.module 'morphs'

morphs.controller 'MapController', class MapController
  constructor: (@$scope, uiGmapGoogleMapApi) ->
    @map = {
      center: { latitude: -30, longitude: 25 }
      zoom: 4
    }

    @marker =  {
      coords: { latitude: -30, longitude: 25}
      options: {
        draggable: true
      }
      id: 'map-marker'
    }

    @$scope.ctrl = @

    @$scope.init = @init

  init: (searchResult, label) =>
    @$scope.$watch 'ctrl.marker.coords', =>
      if Object.keys(searchResult).length != 0
        searchResult.field_values[label] = JSON.stringify @marker.coords
    , true

    @$scope.$watch 'searchResult.field_values', =>
      if searchResult.field_values
        coords = JSON.parse searchResult.field_values[label]
        @marker.coords = coords
    , true
