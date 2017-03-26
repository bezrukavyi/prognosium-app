angular.module('toDoApp').directive 'forecastsChart', () ->
  restrict: 'E'
  replace: true
  templateUrl: 'forecasts/chart.html'
  scope:
    ctrl: '='
    forecast: '='
