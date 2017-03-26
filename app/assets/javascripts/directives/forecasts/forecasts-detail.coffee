angular.module('toDoApp').directive 'forecastsDetail', () ->
  restrict: 'E'
  replace: true
  templateUrl: 'forecasts/detail.html'
  scope:
    ctrl: '='
    forecast: '='
