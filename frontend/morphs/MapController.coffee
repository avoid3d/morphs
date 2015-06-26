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

    events = {
        places_changed: (searchBox) =>
            place = searchBox.getPlaces();
            if !place || place == 'undefined' || place.length == 0
                console.log 'No place data.'
                return

            @map.center = {
              "latitude": place[0].geometry.location.lat(),
              "longitude": place[0].geometry.location.lng()
            }

            @map.zoom = 18

            @marker.coords = {
                latitude: place[0].geometry.location.lat(),
                longitude: place[0].geometry.location.lng()
            };

            console.log @searchResult
            #@searchResult.field_values[label] = JSON.stringify @marker.coords
    };

    @searchbox = {
        template: 'searchbox.tpl.html',
        events: events
    }

    @$scope.ctrl = @

    @$scope.init = @init

  init: (searchResult, label) =>
    @$scope.$watch 'ctrl.marker.coords', =>
      if Object.keys(searchResult).length != 0
        searchResult.field_values[label] = JSON.stringify @marker.coords
        @map.center = window.angular.copy @marker.coords;
    , true

    @$scope.$watch 'searchResult.field_values', =>
      if searchResult.field_values
        coords = JSON.parse searchResult.field_values[label]
        @marker.coords = coords
    , true

    @searchResult = searchResult

