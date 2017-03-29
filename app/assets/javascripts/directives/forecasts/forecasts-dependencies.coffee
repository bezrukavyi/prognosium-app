ForecastsDependencies = () ->
  restrict: 'A'
  scope:
    forecast: '='
    field: '='
  link: (scope, element, attrs) ->
    scope.$watch 'forecast', ((newValue, oldValue) ->
      if newValue
        current_method = scope.forecast.analysis_type
        dependencies = scope.forecast.forecast_dependencies[current_method]
        required = dependencies.includes(scope.field)
        if required
          element.show()
        else
          element.hide()
      return
    ), true
    return

angular.module('toDoApp').directive 'forecastsDependencies', [ForecastsDependencies]
