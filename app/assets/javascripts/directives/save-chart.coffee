SaveChart = () ->
  restrict: 'A'
  scope:
    saveChart: '@'
  link: (scope, element, attrs) ->
    chart = document.getElementById("#{scope.saveChart}")
    element.click ()->
      link = document.createElement('a')
      link.href = chart.toDataURL()
      link.download = 'chart.png'
      link.click()
      link.remove()

angular.module('toDoApp').directive 'saveChart', [SaveChart]
