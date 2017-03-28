Forecast = ($resource, Upload, $translate) ->
  upload: (file, params) ->
    params.id ||= ''
    $.each params, (index, value) -> params[index] ||= ''
    Upload.upload(
      url: "/api/forecasts/#{params.id}",
      data: { file: file, 'forecast': params }, method: 'PUT', locale: $translate.use())

  default: $resource '/api/forecasts/:id', { id: '@id', locale: $translate.use() },
    update:
      method: 'PATCH'
    delete:
      method: 'DELETE'

angular.module('toDoApp').factory 'Forecast', ['$resource', 'Upload', '$translate', Forecast]
