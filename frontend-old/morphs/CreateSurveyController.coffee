morphs = window.angular.module 'morphs'


morphs.controller 'CreateSurveyController', class CreateSurveyController
  constructor: ($scope, @$state, @SurveysService)->
    @create_survey_form = {
      name: null
      comments: null
    }
    
    @survey = {
      name: null
      comments: null
      fields: []
      is_mutable: true
      field_values: {}
    }

    @field_types = [
      {id: 'text', label: 'text'},
      {id:'select', label: 'select'},
      {id: 'radio', label: 'radio'},
      {id: 'location', label: 'location'}
    ]

    @add_field_form = {
      label: null
      field_type: @field_types[0]
      options: null
    }

    $scope.$watch ($scope) =>
      return $scope.ctrl.create_survey_form
    , =>
      @survey.name = @create_survey_form.name
      @survey.comments = @create_survey_form.comments
    , true

    $scope.ctrl = @

  should_show_options: =>
    return @add_field_form.field_type.id in ['select', 'radio']

  add_field: =>
    field = {
      label: @add_field_form.label
      field_type: @add_field_form.field_type.id
    }

    if @add_field_form.options
      field.options = (option.replace /^\s+|\s+$/g, '' for option in @add_field_form.options.split ',')
    @survey.fields.push field

    @add_field_form.label = null
    @add_field_form.field_type = @field_types[0]
    @add_field_form.options = null

  delete_field: (field) =>
    @survey.fields.splice(@survey.fields.indexOf(field), 1);

  create_survey: =>
    survey = {
      name: @create_survey_form.name
      comments: @create_survey_form.comments
      fields: @survey.fields
    }
    @SurveysService.create_survey survey
      .then (survey) =>
        @$state.go 'surveys.details.searches.create', {survey_id: survey.id_}
