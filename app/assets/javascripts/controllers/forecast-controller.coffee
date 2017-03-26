ForecastsController = (Forecast, TodoToast, I18n, Access, $state, $filter) ->
  ctrl = @

  ctrl.update = (form, forecast) ->
    return if form.$invalid
    Forecast.default.update(forecast).$promise.then (
      (response) ->
        Object.assign(task, response)
      ), (response) ->
        TodoToast.error(response.data.error)

  ctrl.upload = (task, forecast, file) ->
    return unless file && Access.can('request')
    options = { task_id: task.id, id: forecast.id }
    Access.lock('request')
    Forecast.upload(file, options, 'put').then (
      (response) ->
        Object.assign(forecast, response.data)
        TodoToast.success(I18n.t('data.success.updated'))
      ), (response) ->
        TodoToast.error(response.data.error)

  return


angular.module('toDoApp').controller 'ForecastsController', [
  'Forecast',
  'TodoToast',
  'I18n',
  'Access',
  '$state',
  '$filter',
  ForecastsController
]
