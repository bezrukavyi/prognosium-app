angular.module('toDoApp').directive 'forecastsTable', () ->
  restrict: 'E'
  replace: true
  templateUrl: 'forecasts/table.html'
  scope:
    ctrl: '='
    forecast: '='
