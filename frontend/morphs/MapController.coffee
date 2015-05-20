morphs = window.angular.module 'morphs'

morphs.controller 'MapController', class MapController
  constructor: ($scope, uiGmapGoogleMapApi) ->
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

    $scope.ctrl = @
