Forecast = ($resource, Upload) ->
  upload: (file, params) ->
    params.id ||= ''
    Upload.upload(
      url: "/api/forecasts/#{params.id}",
      data: { file: file, 'forecast': params }, method: 'PUT')

  default: $resource '/api/forecasts/:id', { id: '@id' },
    update:
      method: 'PATCH'
    delete:
      method: 'DELETE'

angular.module('toDoApp').factory 'Forecast', ['$resource', 'Upload', Forecast]
