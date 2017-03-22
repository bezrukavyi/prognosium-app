angular.module('toDoApp').directive 'projectsList', () ->
  restrict: 'E'
  controller: 'ProjectsController'
  controllerAs: 'projects'
  templateUrl: 'projects/list.html'
  bindToController: true
