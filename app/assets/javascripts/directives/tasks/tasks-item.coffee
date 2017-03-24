angular.module('toDoApp').directive 'tasksItem', () ->
  restrict: 'E'
  replace: true
  templateUrl: 'tasks/item.html'
  scope:
    ctrl: '='
    task: '='
    project: '='
