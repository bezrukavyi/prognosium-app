Task = ($resource, Upload) ->
  upload: (file, params) ->
    params.id ||= ''
    $.each params, (index, value) -> params[index] ||= ''
    Upload.upload(
      url: "/api/projects/#{params.project_id}/tasks/#{params.id}",
      data: { file: file, 'task': params })

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

angular.module('toDoApp').factory 'Task', ['$resource', 'Upload', Task]
