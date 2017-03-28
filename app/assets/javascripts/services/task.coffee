Task = ($resource, Upload, $translate) ->
  upload: (file, params) ->
    params.id ||= ''
    $.each params, (index, value) -> params[index] ||= ''
    Upload.upload(
      url: "/api/projects/#{params.project_id}/tasks/#{params.id}",
      data: { file: file, 'task': params, locale: $translate.use() })

  nested: $resource '/api/projects/:project_id/tasks/:id', { project_id: '@project_id', id: '@id', locale: $translate.use() },
    show:
      method: 'GET'
    create:
      method: 'POST'

  default: $resource '/api/tasks/:id', { id: '@id', locale: $translate.use() },
    update:
      method: 'PATCH'
    delete:
      method: 'DELETE'

angular.module('toDoApp').factory 'Task', ['$resource', 'Upload', '$translate', Task]
