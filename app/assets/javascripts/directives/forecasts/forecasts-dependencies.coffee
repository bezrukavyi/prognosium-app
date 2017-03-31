ForecastsDependencies = () ->
  restrict: 'A'
  scope:
    forecastsDependencies: '='
    field: '='
  link: (scope, element, attrs) ->
    scope.$watch 'forecastsDependencies', ((newValue, oldValue) ->
      forecast = scope.forecastsDependencies
      if newValue
        current_method = forecast.analysis_type
        dependencies = forecast.forecast_dependencies[current_method]
        required = dependencies.includes(scope.field)
        if required
          element.show()
        else
          element.hide()
      return
    ), true
    return

angular.module('toDoApp').directive 'forecastsDependencies', [ForecastsDependencies]
