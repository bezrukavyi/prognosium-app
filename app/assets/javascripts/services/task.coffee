Task = ($resource) ->
  nested: $resource '/api/projects/:project_id/tasks/:id', { project_id: '@project_id', id: '@id' },
    show:
      method: 'GET'
    create:
      method: 'POST'

  default: $resource '/api/tasks/:id', { id: '@id' },
    update:
      method: 'PATCH'
    delete:
      method: 'DELETE'

angular.module('toDoApp').factory 'Task', ['$resource', Task]
