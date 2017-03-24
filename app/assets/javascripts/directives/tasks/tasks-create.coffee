angular.module('toDoApp').directive 'tasksCreate', () ->
  restrict: 'E'
  replace: true
  templateUrl: 'tasks/form-create.html'
  scope:
    ctrl: '='
    project: '='
