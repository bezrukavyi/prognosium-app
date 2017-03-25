Task = ($resource, Upload) ->
  upload: (file, params, method = 'post') ->
    params.id ||= ''
    Upload.upload(
      url: "/api/projects/#{params.project_id}/tasks/#{params.id}",
      data: { file: file, 'task': params },
      method: method)

  default: $resource '/api/projects/:project_id/tasks/:id', { project_id: '@project_id', id: '@id' },
    show:
      method: 'GET'
    create:
      method: 'POST'
    update:
      method: 'PATCH'
    delete:
      method: 'DELETE'

angular.module('toDoApp').factory 'Task', ['$resource', 'Upload', Task]
