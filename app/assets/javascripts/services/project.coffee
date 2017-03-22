Project = ($resource) ->
  $resource '/api/projects/:id', { id: '@id' },
    index:
      method: 'GET'
      isArray: true
    create:
      method: 'POST'
    update:
      method: 'PATCH'
    delete:
      method: 'DELETE'

angular.module('toDoApp').factory 'Project', ['$resource', Project]
