angular.module('toDoApp').directive 'forecastsForm', () ->
  restrict: 'E'
  replace: true
  templateUrl: 'forecasts/form.html'
  scope:
    ctrl: '='
    forecast: '='
    task: '='
