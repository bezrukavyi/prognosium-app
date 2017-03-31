Tooltip = () ->
  restrict: 'E'
  scope:
    text: '='
  link: (scope, element, attrs) ->
    element.addClass('tooltip')
    tooltipText = document.createElement('span')
    tooltipText.className = 'tooltip-text'
    tooltipText.prepend(scope.text)
    element.prepend(tooltipText)
    scope.$watch 'text', ((newValue, oldValue) ->
      tooltipText.innerHTML = scope.text
    ), true

angular.module('toDoApp').directive 'tooltip', [Tooltip]
